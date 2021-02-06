# outgoing imap
class shorewall::rules::out::imap (
  $shorewall6 = true,
) {
  shorewall::rule {
    'me-net-tcp_imap_s':
      source          => '$FW',
      destination     => 'net',
      proto           => 'tcp',
      destinationport => '143,993',
      order           => 260,
      action          => 'ACCEPT',
      shorewall6      => $shorewall6,
  }
}
