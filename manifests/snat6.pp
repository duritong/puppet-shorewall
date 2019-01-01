# http://www.shorewall.net/manpages/shorewall6-snat.html
define shorewall::snat6(
  $action,
  $source,
  $dest,
  $proto       = '-',
  $port        = '-',
  $ipsec       = '-',
  $mark        = '-',
  $user        = '-',
  $switch      = '-',
  $origdest    = '-',
  $probability = '-',
  $order       = '500',
  $ensure      = 'present',
){
  shorewall::snat{
    "${name}_IP6":
      ensure      => $ensure,
      action      => $action,
      source      => $source,
      dest        => $dest,
      proto       => $proto,
      port        => $port,
      ipsec       => $ipsec,
      mark        => $mark,
      user        => $user,
      switch      => $switch,
      origdest    => $origdest,
      probability => $probability,
      order       => $order,
      shorewall   => false,
      shorewall6  => true,
  }
}
