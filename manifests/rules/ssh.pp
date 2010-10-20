class shorewall::rules::ssh($ports) {
  $flatted_ports = join($ports,',')
  shorewall::rule { 'net-me-tcp_ssh':
    source          => 'net',
    destination     => '$FW',
    proto           => 'tcp',
    destinationport => $flatted_ports,
    order           => 240,
    action          => 'ACCEPT';
  }
}
