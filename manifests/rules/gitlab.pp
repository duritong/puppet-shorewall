# manage gitlab ports
define shorewall::rules::gitlab(
  Enum['podman','docker']
    $runtime = 'podman',
  String
    $ip      = $name,
  String
    $source  = 'net',
  Enum['ACCEPT','DROP','REJECT']
    $action  = 'ACCEPT',
) {

  if $runtime == 'docker' {
    shorewall::rule {
      "${source}-me-httpS-gitlab-${name}":
        source          => $source,
        destination     => '$FW',
        proto           => 'tcp',
        destinationport => '80,443',
        order           => 240,
        action          => 'ACCEPT';
    }
  } else {
    shorewall::rule {
      "${source}-me-http-gitlab-${name}":
        source          => $source,
        destination     => "\$FW:${ip}:8080",
        proto           => 'tcp',
        destinationport => '80',
        originaldest    => $ip,
        order           => 240,
        action          => 'DNAT',
        shorewall6      => false;
      "${source}-me-https-gitlab-${name}":
        source          => $source,
        destination     => "\$FW:${ip}:8443",
        proto           => 'tcp',
        destinationport => '443',
        originaldest    => $ip,
        order           => 240,
        action          => 'DNAT',
        shorewall6      => false;
    }
  }
  shorewall::rule {
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
