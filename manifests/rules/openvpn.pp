# openvpn incoming
class shorewall::rules::openvpn {
  shorewall::rule {
    'net-me-openvpn-udp':
      source          => 'net',
      destination     => '$FW',
      proto           => 'udp',
      destinationport => '1194',
      order           => 240,
      action          => 'ACCEPT';
  }
}
