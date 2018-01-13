# outoging oper3
class shorewall::rules::out::pop3(
  $shorewall6 = true,
) {
  shorewall::rule {
    'me-net-tcp_pop3_s':
      source          => '$FW',
      destination     => 'net',
      proto           => 'tcp',
      destinationport => 'pop3,pop3s',
      order           => 260,
      action          => 'ACCEPT',
      shorewall6      => $shorewall6,
  }
}
