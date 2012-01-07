define shorewall::rules::torify::redirect_dns_to_tor() {

  $user = $name

  $destzone = $shorewall::tor_dns_host ? {
    '127.0.0.1' => '$FW',
    default     => 'net'
  }

  $tcp_rule = "redirect-tcp-dns-to-tor-user=${user}"
  if !defined(Shorewall::Rule["$tcp_rule"]) {
    shorewall::rule {
      "$tcp_rule":
        source          => '$FW',
        destination     => "${destzone}:${shorewall::tor_dns_host}:${shorewall::tor_dns_port}",
        proto           => 'tcp',
        destinationport => 'domain',
        user            => $user,
        order           => 108,
        action          => 'DNAT';
    }
  }

  $udp_rule = "redirect-udp-dns-to-tor-user=${user}"
  if !defined(Shorewall::Rule["$udp_rule"]) {
    shorewall::rule {
      "$udp_rule":
        source          => '$FW',
        destination     => "${destzone}:${shorewall::tor_dns_host}:${shorewall::tor_dns_port}",
        proto           => 'udp',
        destinationport => 'domain',
        user            => $user,
        order           => 108,
        action          => 'DNAT';
    }
  }

}
