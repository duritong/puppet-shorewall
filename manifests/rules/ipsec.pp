class shorewall::rules::ipsec {
    shorewall::rule { 'net-me-ipsec-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '500',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'me-net-ipsec-udp':
        source          => '$FW',
        destination     => 'net',
        proto           => 'udp',
        destinationport => '500',
        order           => 240,
        action          => 'ACCEPT';
    }
}
