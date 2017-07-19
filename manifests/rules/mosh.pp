# enable mosh support
class shorewall::rules::mosh {
  shorewall::rule { 'net-me-mosh-udp':
    source          => 'net',
    destination     => '$FW',
    proto           => 'udp',
    destinationport => '60000:61000',
    order           => 240,
    action          => 'ACCEPT';
  }
}
