CREATE TABLE IF NOT EXISTS `int_info_1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `switch_id` int(11) DEFAULT NULL,
  `ingress_port` int(11) DEFAULT NULL,
  `egress_port` int(11) DEFAULT NULL,
  `enq_tstamp` bigint(20) DEFAULT NULL,
  `ingress_tstamp` bigint(20) DEFAULT NULL,
  `deq_timedelta` bigint(20) DEFAULT NULL,
  `process_delay` bigint(20) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;



CREATE TABLE IF NOT EXISTS `int_vxlan_heavy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host_ip` char(30) DEFAULT NULL,
  `int_meta` varchar(1000) NOT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
