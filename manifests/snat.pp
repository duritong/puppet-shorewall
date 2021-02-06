# http://www.shorewall.net/manpages/shorewall-snat.html
# http://www.shorewall.net/manpages6/shorewall6-snat.html
define shorewall::snat (
  $action,
  $source,
  $dest,
  $proto           = '-',
  $port            = '-',
  $ipsec           = '-',
  $mark            = '-',
  $user            = '-',
  $switch          = '-',
  $origdest        = '-',
  $probability     = '-',
  $order           = '500',
  $shorewall       = true,
  $shorewall6      = true,
  $ensure          = 'present',
) {
  $with_shorewall6 = $shorewall6 and $shorewall::with_shorewall6
  shorewall::entry { "snat-${order}-${name}":
    ensure     => $ensure,
    line       => "# ${name}\n${action} ${source} ${dest} ${proto} ${port} ${ipsec} ${mark} ${user} ${switch} ${origdest} ${probability}",
    shorewall  => $shorewall,
    shorewall6 => $with_shorewall6,
  }
}
