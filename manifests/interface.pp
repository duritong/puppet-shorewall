# manage a shorewall-interface entry
# http://www.shorewall.net/manpages/shorewall-interfaces.html
define shorewall::interface (
  $zone,
  $broadcast   = 'detect',
  $options     = 'tcpflags,routefilter,nosmurfs,logmartians',
  $add_options = undef,
  $rfc1918     = false,
  $dhcp        = false,
  $order       = 100,
) {
  $added_opts = $add_options ? {
    ''      => '',
    undef   => '',
    default => ",${add_options}",
  }

  $dhcp_opt = $dhcp ? {
    false   => '',
    default => ',dhcp',
  }

  if versioncmp($facts['shorewall_version'],'4.5') < 0 {
    $rfc1918_opt = $rfc1918 ? {
      false   => ',norfc1918',
      default => '',
    }
  } else {
    $rfc1918_opt = undef
  }
  $all_options = "${options}${dhcp_opt}${rfc1918_opt}${added_opts}"
  if versioncmp($facts['shorewall_version'],'4.5') >= 0 {
    $all_options1 = regsubst($all_options,',(no)?rfc1918','')
  } else {
    $all_options1 = $all_options
  }
  if versioncmp($facts['shorewall_major_version'],'5') >= 0 {
    $all_options2 = regsubst($all_options1,',blacklist','')
  } else {
    $all_options2 = $all_options1
  }

  shorewall::entry { "interfaces-${order}-${name}":
    line       => "${zone} ${name} ${broadcast} ${all_options2}",
    shorewall  => true,
    shorewall6 => false,
  }
  if $shorewall::with_shorewall6 {
    # logmartians is not available on shorewall6
    $all_options3 = regsubst($all_options2,',logmartians','')
    # routefilter is not available in the kernel for ipv6
    $all_options4 = regsubst($all_options3,',routefilter','')
    shorewall::entry { "interfaces-${order}-${name}_6":
      line       => "${zone} ${name} ${all_options4}",
      shorewall  => false,
      shorewall6 => true,
    }
  }
}
