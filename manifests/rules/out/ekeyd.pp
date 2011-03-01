define shorewall::rules::out::ekeyd($ekeyd_host) {
  shorewall::rule { "me-${name}-tcp_ekeyd":
    source          => '$FW',
    destination     => "${name}:${ekeyd_host}",
    proto           => 'tcp',
    destinationport => '8888',
    order           => 240,
    action          => 'ACCEPT';
  }
}
