/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

/* P4 source code for INT over VXLAN */

/********************************************************************
*  headers
*******************************************************************/
#define MAX_HOP_CNT 10

/* ethernet header: 14 bytes */
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

/* ipv4 header: 20 bytes */
header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

/* udp header: 8 bytes */
header udp_t {
    bit<16>  srcPort;
    bit<16>  dstPort;
    bit<16>  length_;
    bit<16>  udpChecksun;
}

/* vxlan header: 8 bytes */
header vxlan_gpe_t {
    bit<8>  flags;
    bit<24> rsvd0; // be set to 0 on transmission, ignored on receipt.
    bit<24> vni;
    bit<8>  rsvd1;
}

/* VxLan GPE shim header: 4 bytes */
header vxlan_gpe_int_header_t {
    bit<8>  int_type;
    bit<8>  rsvd;
    bit<8>  len;
    bit<8>  next_proto; // as next_proto, 0x05 for INT
}

/* INT header: 8 bytes */
header int_header_t {
    bit<2>  ver;
    bit<2>  rep;
    bit<1>  c;
    bit<1>  e;
    bit<5>  rsvd1;
    bit<5>  ins_cnt;
    bit<8>  max_hop_cnt;
    bit<8>  total_hop_cnt;
    bit<4>  instruction_mask_0003; /* split the bits for lookup */
    bit<4>  instruction_mask_0407;
    bit<4>  instruction_mask_0811;
    bit<4>  instruction_mask_1215;
    bit<16> rsvd2;
}

/* INT meta­value headers ­ different header for each value type */
header int_switch_id_t {
    bit<32> switch_id;
}
header int_port_id_t {
    bit<16> ingress_port_id;
    bit<16> egress_port_id;
}
header int_hop_latency_t {
    bit<32> hop_latency;
}
header int_q_occupancy_t {
    bit<8>  q_occupancy_id;
    bit<24> q_occupancy;
}
header int_ingress_tstamp_t {
    bit<48> ingress_tstamp;
}
header int_egress_tstamp_t {
    bit<48> egress_tstamp;
}
header int_q_congestion_t {
    bit<32> q_congestion;
}
header int_egress_port_tx_utilization_t {
    bit<32> egress_port_tx_utilization;
}

struct headers {
    ethernet_t                                    ethernet;
    ipv4_t                                        ipv4;
    udp_t                                         udp;
    vxlan_gpe_t                                   vxlan_gpe;
    vxlan_gpe_int_header_t                        vxlan_gpe_int_header;
    int_header_t                                  int_header;
    int_switch_id_t[MAX_HOP_CNT]                  int_switch_id;
    int_port_id_t[MAX_HOP_CNT]                    int_port_id;
    int_hop_latency_t[MAX_HOP_CNT]                int_hop_latency;
    int_q_occupancy_t[MAX_HOP_CNT]                int_q_occupancy;
    int_ingress_tstamp_t[MAX_HOP_CNT]             int_ingress_tstamp;
    int_egress_tstamp_t[MAX_HOP_CNT]              int_egress_tstamp;
    int_q_congestion_t[MAX_HOP_CNT]               int_q_congestion;
    int_egress_port_tx_utilization_t[MAX_HOP_CNT] int_egress_port_tx_utilization;
}

/* switch internal variables for INT logic implementation */
struct int_metadata_t{
    bit<32> switch_id;
    bit<24> vni;
}

struct metadata {
    int_metadata_t  int_metadata;
}

/*************************************************************************
*  parser
*************************************************************************/
#define INGRESS_TUNNEL_TYPE_VXLAN_GPE 100

parser MyParser (packet_in packet,
                 out headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    state start {
        transition parse_ethernet;
    }

    /* Ethernet */
    state parse_ethernet {
	  packet.extract(hdr.ethernet);
          transition select(hdr.ethernet.etherType) {
              0x0800  : parse_ipv4;
              default : accept;
              }
    }

    /* IPv4 */
    state parse_ipv4 {
	packet.extract(hdr.ipv4);
	transition select(hdr.ipv4.protocol) {
            17      : parse_udp;
            default : accept;
	    }
    }

    /* UDP */
    state parse_udp {
        packet.extract(hdr.udp);
        transition select(hdr.udp.dstPort) {
            4790    : parse_vxlan_gpe;
            default : accept;
        }
    }

    /* VXLAN */
    state parse_vxlan_gpe {
        packet.extract(hdr.vxlan_gpe);
        transition select(hdr.vxlan_gpe.vni) {
            0x100   : parse_gpe_int_header;
            default : accept;
        }
    }

    /* GPE INT */
    state parse_gpe_int_header {
        packet.extract(hdr.vxlan_gpe_int_header);
        transition select(hdr.vxlan_gpe_int_header.next_proto) {
            0x05    : parse_int_header;
            default : accept;
        }
    }

    /* INT */
    state parse_int_header {
        packet.extract(hdr.int_header);
	transition select(hdr.int_header.rsvd1) {
            0       : accept;
            default : parse_all_int_meta_values_dummy;
        }
    }

    state parse_all_int_meta_values_dummy {
        packet.extract(hdr.int_switch_id[0]);
        packet.extract(hdr.int_port_id[0]);
        packet.extract(hdr.int_hop_latency[0]);
        packet.extract(hdr.int_q_occupancy[0]);
        packet.extract(hdr.int_ingress_tstamp[0]);
        packet.extract(hdr.int_egress_tstamp[0]);
        packet.extract(hdr.int_q_congestion[0]);
        packet.extract(hdr.int_egress_port_tx_utilization[0]);
        transition accept;
    }
}

/*************************************************************************
*  checksum verification
*************************************************************************/
control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {  }
}

/*************************************************************************
*  ingress processing
*************************************************************************/

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    action drop() {
        mark_to_drop();
    }

    action ipv4_forward(bit<48> dstAddr, bit<9> port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.int_header.total_hop_cnt = hdr.int_header.total_hop_cnt + 1;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr : lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = NoAction();
    }

    apply {
        if (hdr.ipv4.isValid()) {
            ipv4_lpm.apply();
        }
    }
}

/*************************************************************************
*  egress processing
*************************************************************************/
control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {

    // instruction
    action int_set_header_0(bit<32> switch_id) { // switch id
        meta.int_metadata.switch_id = switch_id;
        hdr.int_switch_id.push_front(1);
        hdr.int_switch_id[0].setValid();
        hdr.int_switch_id[0].switch_id = meta.int_metadata.switch_id;
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    action int_set_header_1() {  // ingress and egress ports
        hdr.int_port_id.push_front(1);
        hdr.int_port_id[0].setValid();
        hdr.int_port_id[0].ingress_port_id = (bit<16>)standard_metadata.ingress_port;
        hdr.int_port_id[0].egress_port_id = (bit<16>)standard_metadata.egress_port;
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    action int_set_header_2() { // hop latency
        hdr.int_hop_latency.push_front(1);
        hdr.int_hop_latency[0].setValid();
        hdr.int_hop_latency[0].hop_latency = standard_metadata.deq_timedelta;//queuing delay
        //or: (bit<32>)(standard_metadata.egress_global_timestamp - (bit<48>)standard_metadata.enq_timestamp);
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    action int_set_header_3() { // q occupency
        hdr.int_q_occupancy.push_front(1);
        hdr.int_q_occupancy[0].setValid();
        hdr.int_q_occupancy[0].q_occupancy_id = 0; //(bit<8>) standard_metadata.egress_qid; // egress qid is not yet exposed in v1model.p4
        hdr.int_q_occupancy[0].q_occupancy = (bit<24>) standard_metadata.enq_qdepth; //the depth of queue when the packet was dequeued.
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    action int_set_header_4() { //ingress_timestamp
        hdr.int_ingress_tstamp.push_front(1);
        hdr.int_ingress_tstamp[0].setValid();
        hdr.int_ingress_tstamp[0].ingress_tstamp = (bit<48>) standard_metadata.enq_timestamp;//standard_metadata.ingress_global_timestamp;
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    action int_set_header_5() { //egress_timestamp
        hdr.int_egress_tstamp.push_front(1);
        hdr.int_egress_tstamp[0].setValid();
        hdr.int_egress_tstamp[0].egress_tstamp = (bit<48>) standard_metadata.enq_timestamp - standard_metadata.ingress_global_timestamp;//this is processing delay
        //standard_metadata.egress_global_timestamp;
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    action int_set_header_6() { //q_congestion
        hdr.int_q_congestion.push_front(1);
        hdr.int_q_congestion[0].setValid();
        hdr.int_q_congestion[0].q_congestion = 0;
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }
    action int_set_header_7() { //egress_port_tx_utilization
        hdr.int_egress_port_tx_utilization.push_front(1);
        hdr.int_egress_port_tx_utilization[0].setValid();
        hdr.int_egress_port_tx_utilization[0].egress_port_tx_utilization = 0;
        hdr.vxlan_gpe_int_header.len = hdr.vxlan_gpe_int_header.len + 1;
    }

    table int_inst_0 { actions = { int_set_header_0; } }
    table int_inst_1 { actions = { int_set_header_1; } }
    table int_inst_2 { actions = { int_set_header_2; } }
    table int_inst_3 { actions = { int_set_header_3; } }
    table int_inst_4 { actions = { int_set_header_4; } }
    table int_inst_5 { actions = { int_set_header_5; } }
    table int_inst_6 { actions = { int_set_header_6; } }
    table int_inst_7 { actions = { int_set_header_7; } }

    apply{
        if ((hdr.int_header.instruction_mask_0003 & 0x8) != 0) { int_inst_0.apply(); }
        if ((hdr.int_header.instruction_mask_0003 & 0x4) != 0) { int_inst_1.apply(); }
        if ((hdr.int_header.instruction_mask_0003 & 0x2) != 0) { int_inst_2.apply(); }
        if ((hdr.int_header.instruction_mask_0003 & 0x1) != 0) { int_inst_3.apply(); }
        if ((hdr.int_header.instruction_mask_0407 & 0x8) != 0) { int_inst_4.apply(); }
        if ((hdr.int_header.instruction_mask_0407 & 0x4) != 0) { int_inst_5.apply(); }
        if ((hdr.int_header.instruction_mask_0407 & 0x2) != 0) { int_inst_6.apply(); }
        if ((hdr.int_header.instruction_mask_0407 & 0x1) != 0) { int_inst_7.apply(); }
    }
}

/*************************************************************************
*   checksum computation
*************************************************************************/
control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
    apply {
        update_checksum(
	    hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	      hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
*  deparser
*************************************************************************/
control MyDeparser(packet_out packet, in headers hdr) {
    apply {
	packet.emit(hdr.ethernet);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.udp);
        packet.emit(hdr.vxlan_gpe);
        packet.emit(hdr.vxlan_gpe_int_header);
        packet.emit(hdr.int_header);
        packet.emit(hdr.int_switch_id);
        packet.emit(hdr.int_port_id);
        packet.emit(hdr.int_hop_latency);
        packet.emit(hdr.int_q_occupancy);
        packet.emit(hdr.int_ingress_tstamp);
        packet.emit(hdr.int_egress_tstamp);
        packet.emit(hdr.int_q_congestion);
        packet.emit(hdr.int_egress_port_tx_utilization);
    }
}

/*************************************************************************
*  switch
*************************************************************************/
V1Switch(
    MyParser(),
    MyVerifyChecksum(),
    MyIngress(),
    MyEgress(),
    MyComputeChecksum(),
    MyDeparser()
    ) main;