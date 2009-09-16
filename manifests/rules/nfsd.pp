class shorewall::rules::nfsd {
    shorewall::rule { 'net-me-portmap-tcp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => '111',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-portmap-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '111',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.nfsd-tcp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => '2049',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.nfsd-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '2049',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.statd-tcp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => '4000',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.statd-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '4000',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.lockd-tcp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => '4001',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.lockd-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '4001',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.mountd-tcp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => '4002',
        order           => 240,
        action          => 'ACCEPT';
    }
    shorewall::rule { 'net-me-rpc.mountd-udp':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp',
        destinationport => '4002',
        order           => 240,
        action          => 'ACCEPT';
    }
}
