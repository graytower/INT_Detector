#!/usr/bin/env python
# -*- coding: utf-8 -*-

from mininet.topo import Topo
from mininet.log import setLogLevel, info
from p4_mininet import P4Switch, P4Host
from mininet.cli import CLI
from mininet.net import Mininet
import argparse

parser = argparse.ArgumentParser(description='Fat tree topo demo')
parser.add_argument('--behavioral-exe', help='Path to behavioral executable', type=str, action='store',
                    default='/home/myp4/P4/behavioral-model/targets/simple_switch/simple_switch')
parser.add_argument('--json', help='Path to JSON config file', type=str, action='store', required=True)
parser.add_argument('--server-exe', help='Path to executable to receive INT metadata', type=str, action='store',
                    required=False)
parser.add_argument('--thrift-port', help='Thrift server port for table updates', type=int, action='store',
                    default=9090)

args = parser.parse_args()


class FatTree(Topo):
    k = 0
    CoreSwitch = []  # Core层的交换机
    AggregationSwitch = []  # Aggregation层的交换机
    EdgeSwitch = []  # Edge层的交换机
    Host = []  # 主机

    def __init__(self, k1, sw_path, json_path, thrift_port, pcap_dump):
        Topo.__init__(self)
        self.k = k1
        self.sw_path = sw_path
        self.json_path = json_path
        self.thrift_port = thrift_port
        self.pcap_dump = pcap_dump

        self.add_coreswitch()  # 添加核心交换机
        self.add_edgeswitch()  # 添加边界交换机
        self.add_aggregation()  # 添加聚合交换机
        self.add_host()  # 添加主机
        self.addlink_hostedge()  # 添加host和edge之间的连接
        self.addlink_edgeaggre()  # 添加edge和aggregation的连接
        self.addlink_aggrecore()  # 添加aggregation和core的连接

    def add_edgeswitch(self):  # 每个pod中边界交换机和聚合交换机的数目是一样的
        k = self.k
        nums = k * k / 2
        for index in xrange(nums):
            self.EdgeSwitch.append(
                self.addSwitch(
                    "Edge%d" % (index + 1),
                    sw_path=self.sw_path,
                    json_path=self.json_path,
                    thrift_port=self.thrift_port + (index + 1),
                    pcap_dump=self.pcap_dump,
                    enable_debugger=True
                )
            )

    def add_aggregation(self):
        k = self.k
        nums = k * k / 2  # 每个pod有k/2个聚合交换机
        for index in xrange(nums):
            self.AggregationSwitch.append(
                self.addSwitch(
                    "Aggre%d" % (index + 1),
                    sw_path=self.sw_path,
                    json_path=self.json_path,
                    thrift_port=self.thrift_port + (nums + index + 1),
                    pcap_dump=self.pcap_dump,
                    enable_debugger=True
                )
            )

    def add_coreswitch(self):
        k = self.k
        nums = k * k / 4  # core结点个数为(k/2)^2
        for index in xrange(nums):
            self.CoreSwitch.append(
                self.addSwitch(
                    "Core%d" % (index + 1),
                    sw_path=self.sw_path,
                    json_path=self.json_path,
                    thrift_port=self.thrift_port + (nums * 4 + index + 1),
                    pcap_dump=self.pcap_dump,
                    enable_debugger=True
                )
            )

    def add_host(self):  # 添加主机
        k = self.k
        nums = k * k * k / 4
        for index in xrange(nums):
            self.Host.append(
                self.addHost(
                    'Host%d' % (index + 1),
                    ip="10.0.%d.10/24" % (index + 1),
                    mac='00:0A:00:00:00:%02x' % (index + 1)
                )
            )
            index += 1

    def addlink_hostedge(self):  # 添加主机和边界交换机之间的连接
        k = self.k
        nums = k * k / 2
        h_index = 0
        for s_index in xrange(nums):
            for Offset in range(k / 2):
                self.addLink(self.EdgeSwitch[s_index], self.Host[h_index + Offset])
            h_index += (k / 2)

    def addlink_edgeaggre(self):  # 添加边界层和聚合层的连接
        k = self.k
        a_index = 0
        e_index = 0
        nums = k * k / 2
        while a_index < nums:
            for Offset1 in range(k / 2):
                for Offset2 in range(k / 2):
                    self.addLink(self.EdgeSwitch[e_index + Offset1], self.AggregationSwitch[a_index + Offset2])
            a_index += (k / 2)
            e_index += (k / 2)

    def addlink_aggrecore(self):  # 添加聚合层和核心层的连接
        k = self.k
        nums = k * k / 4
        for c_index in xrange(nums):
            if c_index < nums / 2:
                a_index = 0
            else:
                a_index = 1
            while a_index < (2 * nums):
                self.addLink(self.CoreSwitch[c_index], self.AggregationSwitch[a_index])
                a_index += 2


def main():
    k = 4
    nums_host = k * k * k / 4
    # nums_edge = k * k / 2
    # nums_aggre = k * k / 2
    # nums_core = k * k / 4
    topo = FatTree(
        k,
        args.behavioral_exe,
        args.json,
        args.thrift_port,
        False  # args.pcap_dump,
    )
    net = Mininet(
        topo=topo,
        host=P4Host,
        switch=P4Switch,  # switch = OVSBridge,
        controller=None
    )

    net.start()

    switch_mac = ["00:aa:bb:00:00:%02x" % n for n in xrange(1, nums_host + 1)]
    switch_addr = ["10.0.%d.1" % n for n in xrange(1, nums_host + 1)]

    for n in xrange(nums_host):
        h = net.get('Host%d' % (n + 1))
        h.setARP(switch_addr[n], switch_mac[n])
        h.setDefaultRoute("dev eth0 via %s" % switch_addr[n])

    # Increase MTU on inter-switch links in order to hadle default MTU to host and INT metadata
    # (max 1024 Bytes) without fragmentation. Set MTU to 2524
    # mtu = 1500 + 1024
    # for n in xrange(nums_edge - 1):
    # 	EdgeSwitch = net.get('Edge%s' % (n + 1))
    # 	EdgeSwitch.cmd('ip link set dev Edge%s-eth1 mtu %d' % ((n + 1), mtu))
    # 	EdgeSwitch.cmd('ip link set dev Edge%s-eth2 mtu %d' % ((n + 1), mtu))
    # for n in xrange(nums_aggre - 1):
    # 	AggregationSwitch = net.get('Aggre%s' % (n + 1))
    # 	AggregationSwitch.cmd('ip link set dev Aggre%s-eth1 mtu %d' % ((n + 1), mtu))
    # 	AggregationSwitch.cmd('ip link set dev Aggre%s-eth2 mtu %d' % ((n + 1), mtu))
    # for n in xrange(nums_core - 1):
    # 	CoreSwitch = net.get('Core%s' % (n + 1))
    # 	CoreSwitch.cmd('ip link set dev Core%s-eth1 mtu %d' % ((n + 1), mtu))
    # 	CoreSwitch.cmd('ip link set dev Core%s-eth2 mtu %d' % ((n + 1), mtu))

    CLI(net)
    net.stop()


if __name__ == '__main__':
    setLogLevel('info')
    main()
