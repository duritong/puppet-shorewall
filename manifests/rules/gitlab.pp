# manage gitlab ports
define shorewall::rules::gitlab(
  $ip     = $name,
  $source = 'net',
  $action = 'ACCEPT',
) {
  shorewall::rule {
    "${source}-me-httpS-gitlab-${name}":
      source          => $source,
      destination     => '$FW',
      proto           => 'tcp',
      destinationport => '80,443',
      order           => 240,
      action          => 'ACCEPT';
    "${source}-me-ssh-gitlab-${name}":
      source          => $source,
      destination     => "\$FW:${ip}:22",
      proto           => 'tcp',
      destinationport => '2222',
      order           => 240,
      action          => 'DNAT',
      shorewall6      => false;
  }
}
