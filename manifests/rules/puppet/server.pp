# incoming puppet connection
class shorewall::rules::puppet::server {
  shorewall::rule { 'net-me-tcp_puppet-server':
    source          => 'net',
    destination     => '$FW',
    proto           => 'tcp',
    destinationport => '$PUPPETSERVER_PORT',
    order           => 240,
    action          => 'ACCEPT';
  }
}
