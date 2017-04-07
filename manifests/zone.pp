# define a zone
define shorewall::zone(
  $type,
  $options = '-',
  $in      = '-',
  $out     = '-',
  $parent  = '-',
  $order   = 100,
){
  $real_name = $parent ? { '-' => $name, default => "${name}:${parent}" }
  shorewall::entry { "zones-${order}-${name}":
      line       => "${real_name} ${type} ${options} ${in} ${out}",
      shorewall  => true,
      shorewall6 => false,
  }
  if $shorewall::with_shorewall6 {
    $type6 = $type ? {
      'ipv4'  => 'ipv6',
      'ipsec' => 'ipsec6',
      'bport' => 'bport6',
      default => $type,
    }
    shorewall::entry { "zones-${order}-${name}_6":
      line       => "${real_name} ${type6} ${options} ${in} ${out}",
      shorewall  => false,
      shorewall6 => true,
    }
  }
}

