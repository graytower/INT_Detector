# !/usr/bin/python
import sys
from hdrs import *
from scapy.all import *
from collections import OrderedDict

''' Decode INT packets 
    now data format:
    end [...] [...] ... start end [...] ... start ...'''


class Decode:
    def __init__(self, dict, packs, path):
        self.dict = dict
        self.packs = packs
        self.path = path
        self.decode_pkts()

    # Packets Process
    def decode_pkts(self):
        pkts = []
        pktNum = len(self.packs)
        for n in range(pktNum):
            pkts.append(str(self.packs[n]))

        if pkts is not None:
            print("Decoding packet ...")
            pkt_n = 0
            for pkt in pkts:
                self.process_int(pkt)
                pkt_n += 1
            return self.dict
        else:
            print("Error: invalid pcap file provided")
            sys.exit(1)

    # Packet oriented Process
    def process_int(self, pkt):
        data_obj = {'data': pkt, 'offset': 0}
        # extract headers
        self.header_extract(hdr_eth, data_obj)
        self.header_extract(hdr_ipv4, data_obj)
        self.header_extract(hdr_udp, data_obj)
        self.header_extract(hdr_vxlan, data_obj)
        self.header_extract(hdr_sr, data_obj)
        int_shim_header = self.header_extract(hdr_int_shim, data_obj)
        int_header = self.header_extract(hdr_int, data_obj)

        # INT Instruction Process
        present_options = []
        fields_mask = int_header['instruction_mask_0003']['value'] << 4
        fields_mask |= int_header['instruction_mask_0407']['value'] << 0
        options_in_order = [
            ("switch_id",         hdr_switch_id),
            ("ingress_port",      hdr_ingress_port),
            ("egress_port",       hdr_egress_port),
            ("ingress_tstamp",    hdr_ingress_tstamp),
            ("enq_tstamp",        hdr_enq_tstamp),
            ("deq_timedelta",     hdr_deq_timedelta),
            ("enq_qdepth",        hdr_enq_qdepth),
            ("deq_qdepth",        hdr_deq_qdepth)]

        for i in range(len(options_in_order)):
            if fields_mask & (0x80 >> i):  # get the (i + 1)th bit
                present_options.append(options_in_order[i])

        ins_count = int_header['ins_cnt']['value']
        if len(present_options) != ins_count:
            print("Error: conflicting instruction count %d and instruction mask (%x) with %d bits set" % (ins_count, fields_mask, len(present_options)))
            sys.exit(1)

        opt_len = int_shim_header['len']['value'] - 3  # 2xLW for int_header + 1xLW int_shim_header;
        if opt_len % ins_count:
            print("Error: options length %d is not a multiple of instruction count %d " % (opt_len, ins_count))
            sys.exit(1)

        opt_sets = opt_len / ins_count  # number of switches
        self.path.append('end')
        for opt_set in range(opt_sets):
            for option_name, option_header in present_options:
                hdr = self.header_extract(option_header, data_obj)
                self.header_print(hdr)
        self.path.append('start')

    # Byte oriented Header Extract
    def header_extract(self, hdr_def, data_obj):
        leftover_width = 0
        leftover_value = 0
        ret = OrderedDict()

        # Iterate over Each Field
        for key, width in hdr_def.items():
            toget = width
            field_value = 0
            ret[key] = {'width': width}
            while toget:
                if leftover_width:
                    chunk_width = min(leftover_width, toget)
                    leftover_width = leftover_width - chunk_width
                    chunk_value = leftover_value >> leftover_width
                    leftover_value = leftover_value & (((1 << chunk_width) - 1) << leftover_width)
                else:
                    # Byte oriented Header Decode
                    chunk_width = min(8, toget)
                    chunk_value = ord(data_obj['data'][data_obj['offset']])  # decode the (offset + 1)th byte in pkt
                    if chunk_width != 8:  # when less than 1 byte
                        leftover_width = 8 - chunk_width
                        leftover_value = chunk_value & ((1 << leftover_width) - 1)
                        chunk_value >>= leftover_width
                    data_obj['offset'] += 1
                field_value |= chunk_value << (toget - chunk_width)
                toget -= chunk_width

            ret[key]['value'] = field_value

        if leftover_width:
            print('Error: bad header definition - not byte aligned !')
            sys.exit(1)
        return ret

    # Switch oriented INT Information Add
    def header_print(self, hdr):
        for fld, fldobj in hdr.items():
            if fld == 'switch_id':
                self.dict['switch_id'].append(fldobj['value'])
                self.path.append(str(fldobj['value']))
            elif fld == 'ingress_port':
                self.dict['ingress_port'].append(fldobj['value'])
            elif fld == 'egress_port':
                self.dict['egress_port'].append(fldobj['value'])
            elif fld == 'ingress_tstamp':
                self.dict['ingress_tstamp'].append(fldobj['value'])
            elif fld == 'enq_tstamp':
                self.dict['enq_tstamp'].append(fldobj['value'])
            elif fld == 'deq_timedelta':
                self.dict['deq_timedelta'].append(fldobj['value'])
            elif fld == 'enq_qdepth':
                self.dict['enq_qdepth'].append(fldobj['value'])
            elif fld == 'deq_qdepth':
                self.dict['deq_qdepth'].append(fldobj['value'])


if __name__ == "__main__":
    pass
