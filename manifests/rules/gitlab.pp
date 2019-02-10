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
      destination     => "\$FW:${ip}:2222",
      proto           => 'tcp',
      destinationport => '22',
      originaldest    => $ip,
      order           => 240,
      action          => 'DNAT',
      shorewall6      => false;
  }
}
