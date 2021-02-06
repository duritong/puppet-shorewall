# open ports used by a jabberserver
# in and outbound.
class shorewall::rules::jabberserver (
  $open_stun = true,
  $outgoing_ports = '5260,5269,5270,5271,5272'
) {
  $incom_ports = '443,5222,5223,5269,5443,7777'
  shorewall::rule {
    'net-me-redirect-jabber_web_redirect':
      source          => 'net,$FW',
      destination     => '5443',
      proto           => 'tcp',
      destinationport => '443',
      order           => 240,
      action          => 'REDIRECT';
  }
  shorewall::rule {
    'net-me-tcp_jabber':
      source          => 'net',
      destination     => '$FW',
      proto           => 'tcp',
      destinationport => $incom_ports,
      order           => 240,
      action          => 'ACCEPT';
    'me-net-tcp_jabber_s2s':
      source      => '$FW',
      sourceport  => '5269',
      destination => 'net',
      proto       => 'tcp',
      order       => 240,
      action      => 'ACCEPT';
    'me-net-tcp_jabber_s2s_2':
      source          => '$FW',
      destination     => 'net',
      proto           => 'tcp',
      destinationport => join(any2array($outgoing_ports),','),
      order           => 240,
      action          => 'ACCEPT';
  }

  if $open_stun {
    shorewall::rule {
      'net-me-udp_jabber_stun_server':
        source          => 'net',
        destination     => '$FW',
        proto           => 'udp,tcp',
        destinationport => '3478,5349',
        order           => 240,
        action          => 'ACCEPT';
    }
  }
}
