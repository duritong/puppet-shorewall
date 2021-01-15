# outgoing smtps
class shorewall::rules::out::smtps {
  shorewall::rule {
    'me-net-tcp_smtps':
      source          => '$FW',
      destination     => 'net',
      proto           => 'tcp',
      destinationport => 'smtps',
      order           => 240,
      action          => 'ACCEPT';
  }
}
