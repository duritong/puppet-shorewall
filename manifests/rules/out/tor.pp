# open outgoing port to connect to the network
class shorewall::rules::out::tor {
  shorewall::rule{'me-net-tor-tcp':
    source          => '$FW',
    destination     => 'net',
    proto           => 'tcp',
    destinationport => '9001',
    order           => 240,
    action          => 'ACCEPT';
  }
}
