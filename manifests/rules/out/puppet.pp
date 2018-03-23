# outgoing puppet traffic
class shorewall::rules::out::puppet(
  $puppetserver          = "puppet.${::domain}",
  $puppetserver_port     = 8140,
  $shorewall6            = true,
) {
  class{'shorewall::rules::puppet':
    puppetserver          => $puppetserver,
    puppetserver_port     => $puppetserver_port,
    shorewall6            => $shorewall6,
  }
  # we want to connect to the puppet server
  shorewall::rule { 'me-net-puppet_tcp':
    source          => '$FW',
    destination     => 'net:$PUPPETSERVER',
    proto           => 'tcp',
    destinationport => '$PUPPETSERVER_PORT',
    order           => 340,
    shorewall6      => $shorewall6,
    action          => 'ACCEPT';
  }
}
