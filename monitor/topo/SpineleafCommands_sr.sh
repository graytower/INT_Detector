#!/bin/bash

switch_CLI=simple_switch_CLI

# Switch (s1)
$switch_CLI --thrift-port 9091 << EOF
table_add int_inst_0 int_set_header_0 => 1
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 1
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 2
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s2)
$switch_CLI --thrift-port 9092 << EOF
table_add int_inst_0 int_set_header_0 => 2
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 1
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 2
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s3)
$switch_CLI --thrift-port 9093 << EOF
table_add int_inst_0 int_set_header_0 => 3
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 1
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 2
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s4)
$switch_CLI --thrift-port 9094 << EOF
table_add int_inst_0 int_set_header_0 => 4
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 1
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 2
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s5)
$switch_CLI --thrift-port 9095 << EOF
table_add int_inst_0 int_set_header_0 => 5
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 1
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 2
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s6)
$switch_CLI --thrift-port 9096 << EOF
table_add int_inst_0 int_set_header_0 => 6
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 1
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 2
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s7)
$switch_CLI --thrift-port 9097 << EOF
table_add int_inst_0 int_set_header_0 => 7
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 1
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 2
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 3
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 3
table_add dosr srrouting =>
EOF

# Switch (s8)
$switch_CLI --thrift-port 9098 << EOF
table_add int_inst_0 int_set_header_0 => 8
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 3
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 3
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 3
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 3
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 3
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 3
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 3
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 3
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 3
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 3
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 3
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 3
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 1
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 2
table_add dosr srrouting =>
EOF

# Switch (s9)
$switch_CLI --thrift-port 9099 << EOF
table_add int_inst_0 int_set_header_0 => 9
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 1
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 1
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 2
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 2
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 4
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 4
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 5
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 5
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 6
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 6
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 7
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 7
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 8
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 8
table_add dosr srrouting =>
EOF

# Switch (s10)
$switch_CLI --thrift-port 9100 << EOF
table_add int_inst_0 int_set_header_0 => 10
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 1
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 1
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 2
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 2
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 4
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 4
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 5
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 5
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 6
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 6
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 7
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 7
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 8
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 8
table_add dosr srrouting =>
EOF

# Switch (s11)
$switch_CLI --thrift-port 9101 << EOF
table_add int_inst_0 int_set_header_0 => 11
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 1
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 1
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 2
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 2
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 4
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 4
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 5
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 5
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 6
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 6
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 7
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 7
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 8
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 8
table_add dosr srrouting =>
EOF

# Switch (s12)
$switch_CLI --thrift-port 9102 << EOF
table_add int_inst_0 int_set_header_0 => 12
table_add int_inst_1 int_set_header_1 =>
table_add int_inst_2 int_set_header_2 =>
table_add int_inst_3 int_set_header_3 =>
table_add int_inst_4 int_set_header_4 =>
table_add int_inst_5 int_set_header_5 =>
table_add int_inst_6 int_set_header_6 =>
table_add int_inst_7 int_set_header_7 =>
table_add ipv4_lpm ipv4_forward 10.0.1.10/24 => 00:0a:00:00:00:01 1
table_add ipv4_lpm ipv4_forward 10.0.2.10/24 => 00:0a:00:00:00:02 1
table_add ipv4_lpm ipv4_forward 10.0.3.10/24 => 00:0a:00:00:00:03 2
table_add ipv4_lpm ipv4_forward 10.0.4.10/24 => 00:0a:00:00:00:04 2
table_add ipv4_lpm ipv4_forward 10.0.5.10/24 => 00:0a:00:00:00:05 3
table_add ipv4_lpm ipv4_forward 10.0.6.10/24 => 00:0a:00:00:00:06 3
table_add ipv4_lpm ipv4_forward 10.0.7.10/24 => 00:0a:00:00:00:07 4
table_add ipv4_lpm ipv4_forward 10.0.8.10/24 => 00:0a:00:00:00:08 4
table_add ipv4_lpm ipv4_forward 10.0.9.10/24 => 00:0a:00:00:00:09 5
table_add ipv4_lpm ipv4_forward 10.0.10.10/24 => 00:0a:00:00:00:10 5
table_add ipv4_lpm ipv4_forward 10.0.11.10/24 => 00:0a:00:00:00:11 6
table_add ipv4_lpm ipv4_forward 10.0.12.10/24 => 00:0a:00:00:00:12 6
table_add ipv4_lpm ipv4_forward 10.0.13.10/24 => 00:0a:00:00:00:13 7
table_add ipv4_lpm ipv4_forward 10.0.14.10/24 => 00:0a:00:00:00:14 7
table_add ipv4_lpm ipv4_forward 10.0.15.10/24 => 00:0a:00:00:00:15 8
table_add ipv4_lpm ipv4_forward 10.0.16.10/24 => 00:0a:00:00:00:16 8
table_add dosr srrouting =>
EOF