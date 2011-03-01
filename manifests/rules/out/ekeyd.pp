class shorewall::rules::out::ekeyd($ekeyd_host) {
  shorewall::rule { 'me-net-tcp_ekeyd':
    source          => '$FW',
    destination     => "net:${ekeyd_host}",
    proto           => 'tcp',
    destinationport => '8888',
    order           => 240,
    action          => 'ACCEPT';
  }
}

