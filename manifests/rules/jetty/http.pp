class shorewall::rules::jetty::http {
  # dnat
  shorewall::rule {
    'dnat-http-to-jetty':
      destination     => "net:${facts['networking']['ip']}:8080",
      destinationport => '80',
      source          => 'net',
      proto           => 'tcp',
      order           => 140,
      action          => 'DNAT';
  }
}
