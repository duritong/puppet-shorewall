# http://www.shorewall.net/manpages/shorewall-snat.html
define shorewall::snat4(
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
    $name:
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
      shorewall   => true,
      shorewall6  => false,
  }
}
