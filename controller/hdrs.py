# !/usr/bin/python
from scapy.all import *
from scapy.packet import *
from scapy.fields import *
from collections import OrderedDict


# Header Definitions for Sending #

class SR(Packet):
    name = "hdr_SR"
    fields_desc = [BitField("routingList", 0, 512)]


class HDR_INT_Shim(Packet):
    name = "hdr_int_shim"
    fields_desc = [XByteField("int_type", 0),
                   XByteField("rsvd", 0),
                   XByteField("len", 3),
                   XByteField("next_proto", 0)]


class HDR_INT(Packet):
    name = "hdr_int"
    fields_desc = [BitField("ver", 0, 2),
                   BitField("rep", 0, 2),
                   BitField("c", 0, 1),
                   BitField("e", 0, 1),
                   BitField("rsvd1", 0, 5),
                   BitField("ins_cnt", 0, 5),
                   XByteField("max_hop_cnt", 0x0a),
                   XByteField("total_hop_cnt", 0),
                   BitField("instruction_mask_0003", 0, 4),
                   BitField("instruction_mask_0407", 0, 4),
                   BitField("instruction_mask_0811", 0, 4),
                   BitField("instruction_mask_1215", 0, 4),
                   XShortField("rsvd2", 0)]


class INT_META(Packet):
    name = "all_int_meta_values"
    fields_desc = [BitField("switch_id", 0, 32),
                   BitField("ingress_port", 0, 16),
                   BitField("egress_port", 0, 16),
                   BitField("ingress_tstamp", 0, 48),
                   BitField("enq_tstamp", 0, 32),
                   BitField("deq_timedelta", 0, 32),
                   BitField("enq_qdepth", 0, 32),
                   BitField("deq_qdepth", 0, 32)]


class PAYLOAD(Packet):
    name = "payload"
    fields_desc = [BitField("load", 1, 6000)]


# Header definitions for Receiving #

int_dict = OrderedDict()
int_dict['switch_id'] = []
int_dict['ingress_port'] = []
int_dict['egress_port'] = []
int_dict['ingress_tstamp'] = []
int_dict['enq_tstamp'] = []
int_dict['deq_timedelta'] = []
int_dict['enq_qdepth'] = []
int_dict['deq_qdepth'] = []

# Header definitions for Decoding #

hdr_eth = OrderedDict()
hdr_eth['dstAddr'] = 48
hdr_eth['srcAddr'] = 48
hdr_eth['etherType'] = 16

hdr_ipv4 = OrderedDict()
hdr_ipv4['version'] = 4
hdr_ipv4['ihl'] = 4
hdr_ipv4['diffserv'] = 8
hdr_ipv4['totalLen'] = 16
hdr_ipv4['identification '] = 16
hdr_ipv4['flags'] = 3
hdr_ipv4['fragOffset'] = 13
hdr_ipv4['ttl'] = 8
hdr_ipv4['protocol'] = 8
hdr_ipv4['hdrChecksum'] = 16
hdr_ipv4['srcAddr'] = 32
hdr_ipv4['dstAddr'] = 32

hdr_udp = OrderedDict()
hdr_udp['srcPort'] = 16
hdr_udp['dstPort'] = 16
hdr_udp['length'] = 16
hdr_udp['checksum'] = 16

hdr_vxlan = OrderedDict()
hdr_vxlan['flags'] = 8
hdr_vxlan['rsvd0'] = 24
hdr_vxlan['vni'] = 24
hdr_vxlan['rsvd1'] = 8

hdr_sr = OrderedDict()
hdr_sr['routingList'] = 512

hdr_int_shim = OrderedDict()
hdr_int_shim['int_type'] = 8
hdr_int_shim['rsvd'] = 8
hdr_int_shim['len'] = 8
hdr_int_shim['next_proto'] = 8

hdr_int = OrderedDict()
hdr_int['ver'] = 2
hdr_int['rep'] = 2
hdr_int['c'] = 1
hdr_int['e'] = 1
hdr_int['rsvd1'] = 5
hdr_int['ins_cnt'] = 5
hdr_int['max_hop_cnt'] = 8
hdr_int['total_hop_cnt'] = 8
hdr_int['instruction_mask_0003'] = 4
hdr_int['instruction_mask_0407'] = 4
hdr_int['instruction_mask_0811'] = 4
hdr_int['instruction_mask_1215'] = 4
hdr_int['rsvd2'] = 16

hdr_switch_id = OrderedDict()
hdr_switch_id['switch_id'] = 32
hdr_ingress_port = OrderedDict()
hdr_ingress_port['ingress_port'] = 16
hdr_egress_port = OrderedDict()
hdr_egress_port['egress_port'] = 16
hdr_enq_tstamp = OrderedDict()
hdr_enq_tstamp['enq_tstamp'] = 32
hdr_ingress_tstamp = OrderedDict()
hdr_ingress_tstamp['ingress_tstamp'] = 48
hdr_process_delay = OrderedDict()
hdr_process_delay['process_delay'] = 48
hdr_inout_delay = OrderedDict()
hdr_inout_delay['inout_delay'] = 48
hdr_deq_timedelta = OrderedDict()
hdr_deq_timedelta['deq_timedelta'] = 32
hdr_enq_qdepth = OrderedDict()
hdr_enq_qdepth['enq_qdepth'] = 32
hdr_deq_qdepth = OrderedDict()
hdr_deq_qdepth['deq_qdepth'] = 32
