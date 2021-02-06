# manage gitlab ports
define shorewall::rules::gitlab (
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
  Hash
  $out_rules = {},
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
    shorewall::snat4 {
      "pin-outgoing-ip-${ip}-for-${name}":
        action => "SNAT(${ip})",
        source => '-',
        dest   => $out_interface,
        user   => "${user}:${group}",
    }
    $default_rule_params = {
      action      => 'ACCEPT',
      source      => '$FW',
      proto       => 'tcp',
      # we assume source of incoming packets is our out dest
      destination => $source,
    }
    $default_rules = {
      'https' => {
        destinationport => '443',
      },
      'ssh' => {
        destinationport => '22',
      },
      'git' => {
        destinationport => '9148',
      },
    }
    ($default_rules + $out_rules).each |$rule,$values| {
      $rule_params = $default_rule_params + $values + { user => "${user}:${group}" }
      shorewall::rule {
        "gitlab-${name}-${rule}":
          * => $rule_params,
      }
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
