class shorewall::rules::ipsec {
    shorewall::rule {
      'net-me-ipsec-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '500',
        order           => 240,
        action          => 'ACCEPT';
      'me-net-ipsec-udp':
        source          => '$FW',
        destination     => 'net',
        proto           => 'udp',
        destinationport => '500',
        order           => 240,
        action          => 'ACCEPT';
      'net-me-ipsec':
        source          => 'net',
        destination     => '$FW',
        proto           => 'esp',
        order           => 240,
        action          => 'ACCEPT';
      'me-net-ipsec':
        source          => '$FW',
        destination     => 'net',
        proto           => 'esp',
        order           => 240,
        action          => 'ACCEPT';
    }
}
