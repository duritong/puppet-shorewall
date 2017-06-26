# a core wrapper for all kinds of entries
define shorewall::entry(
    $shorewall  = true,
    $shorewall6 = false,
    $line
){
  $parts = split($name,'-')
  if $shorewall {
    concat::fragment{$name:
      content => "${line}\n",
      order   => $parts[1],
      target  => "/etc/shorewall/puppet/${parts[0]}",
    }
  }
  if $shorewall6 and $shorewall::with_shorewall6 {
    concat::fragment{"shorewall6_${name}":
      content => "${line}\n",
      order   => $parts[1],
      target  => "/etc/shorewall6/puppet/${parts[0]}",
    }
  }
}
