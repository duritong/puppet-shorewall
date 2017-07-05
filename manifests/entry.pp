# a core wrapper for all kinds of entries
define shorewall::entry(
  $line,
  $ensure     = present,
  $shorewall  = true,
  $shorewall6 = false,
){
  if $ensure == 'present' {
    $parts = split($name,'-')
    if $shorewall {
      concat::fragment{$name:
        ensure  => $ensure,
        content => "${line}\n",
        order   => $parts[1],
        target  => "/etc/shorewall/puppet/${parts[0]}",
      }
    }
    if $shorewall6 and $shorewall::with_shorewall6 {
      concat::fragment{"shorewall6_${name}":
        ensure  => $ensure,
        content => "${line}\n",
        order   => $parts[1],
        target  => "/etc/shorewall6/puppet/${parts[0]}",
      }
    }
  }
}
