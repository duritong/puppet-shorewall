class shorewall::rules::ssh {
    shorewall::rule { 'net-me-tcp_ssh':
        source          => 'net',
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => 'ssh',
        order           => 240,
        action          => 'ACCEPT';
    }
}
