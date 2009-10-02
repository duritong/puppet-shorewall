class shorewall::rules::out::puppet {
    include ::shorewall::rules::puppet
    # we want to connect to the puppet server
    shorewall::rule { 'me-net-puppet_tcp':
        source          =>      '$FW',
        destination     =>      'net:$PUPPETSERVER',
        proto           =>      'tcp',
        destinationport =>      '$PUPPETSERVER_PORT,$PUPPETSERVER_SIGN_PORT',
        order           =>      340,
        action          =>      'ACCEPT';
    }
}
