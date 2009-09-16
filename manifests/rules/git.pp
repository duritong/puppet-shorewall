class shorewall::rules::git {
    shorewall::rule{'me-net-git-tcp':
        source          => '$FW',
        destination     => 'net',
        proto           => 'tcp',
        destinationport => '9418',
        order           => 240,
        action          => 'ACCEPT';
    }
}
