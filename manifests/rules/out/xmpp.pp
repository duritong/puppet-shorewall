class shorewall::rules::out::xmppp {
    shorewall::rule{'me-net-xmpp-tcp':
        source          => '$FW',
        destination     => 'net',
        proto           => 'tcp',
        destinationport => '5222',
        order           => 240,
        action          => 'ACCEPT';
    }
}
