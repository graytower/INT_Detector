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


class SpineLeaf(Topo):
    spine = 0
    leaf = 0
    host = 0
    SpineSwitch = []  # spine的交换机
    LeafSwitch = []  # leaf层的交换机
    Host = []  # 主机

    def __init__(self, spine, leaf, host, sw_path, json_path, thrift_port, pcap_dump):
        Topo.__init__(self)
        self.spine = spine
        self.leaf = leaf
        self.host = host
        self.sw_path = sw_path
        self.json_path = json_path
        self.thrift_port = thrift_port
        self.pcap_dump = pcap_dump

        self.add_leafswitch()  # 添加leaf交换机
        self.add_spineswitch()  # 添加spine交换机
        self.add_host()  # 添加主机
        self.addlink_hostleaf()
        self.addlink_leafspine()

    def add_leafswitch(self):
        for index in range(self.leaf):
            self.LeafSwitch.append(
                self.addSwitch(
                    "l%d" % (index + 1),
                    sw_path=self.sw_path,
                    json_path=self.json_path,
                    thrift_port=self.thrift_port + (index + 1),
                    pcap_dump=self.pcap_dump,
                    enable_debugger=True
                )
            )

    def add_spineswitch(self):
        for index in range(self.spine):
            self.SpineSwitch.append(
                self.addSwitch(
                    "s%d" % (index + 1),
                    sw_path=self.sw_path,
                    json_path=self.json_path,
                    thrift_port=self.thrift_port + (self.leaf + index + 1),
                    pcap_dump=self.pcap_dump,
                    enable_debugger=True
                )
            )

    def add_host(self):  # 添加主机
        for index in range(self.host):
            self.Host.append(
                self.addHost(
                    'h%d' % (index + 1),
                    ip="10.0.%d.10/24" % (index + 1),
                    mac='00:0A:00:00:00:%02x' % (index + 1)
                )
            )
            index += 1

    def addlink_hostleaf(self):
        for index in range(self.leaf):
            self.addLink(self.LeafSwitch[index], self.Host[index * 2])
            self.addLink(self.LeafSwitch[index], self.Host[index * 2 + 1])

    def addlink_leafspine(self):
        for index1 in range(self.spine):
            for index2 in range(self.leaf):
                self.addLink(self.LeafSwitch[index2], self.SpineSwitch[index1])


def main():
    spine = 4
    leaf = 8
    host = 16

    topo = SpineLeaf(
        spine, leaf, host,
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

    switch_mac = ["00:aa:bb:00:00:%02x" % n for n in range(1, host + 1)]
    switch_addr = ["10.0.%d.1" % n for n in range(1, host + 1)]

    for n in range(host):
        h = net.get('h%d' % (n + 1))
        h.setARP(switch_addr[n], switch_mac[n])
        h.setDefaultRoute("dev eth0 via %s" % switch_addr[n])

    CLI(net)
    net.stop()


if __name__ == '__main__':
    setLogLevel('info')
    main()
