# manage gitlab ports
define shorewall::rules::gitlab(
  Enum['podman','docker']
    $runtime = 'podman',
  String
    $ip      = $name,
  String
    $source  = 'net',
  Optional[String]
    $out_interface = $facts['default_interface'],
  Optional[String]
    $user = undef,
  Optional[String]
    $group = undef,
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
    if !$user or !$group or !$out_interface {
      fail("You need to pass user, group and out_interface parameter for ${name}")
    }
    shorewall::snat4{
      "pin-outgoing-ip-${ip}-for-${name}":
        action => "SNAT(${ip})",
        source => "-",
        dest   => $out_interface,
        user   => "${user}:${group}",
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
