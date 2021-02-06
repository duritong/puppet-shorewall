# open smtp submit port
class shorewall::rules::out::smtp_submit {
  shorewall::rule {
    'me-net-tcp_smtp_submit':
      source          => '$FW',
      destination     => 'net',
      proto           => 'tcp',
      destinationport => '587',
      order           => 240,
      action          => 'ACCEPT';
  }
}
