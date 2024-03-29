define shorewall::routestopped (
  $interface = $name,
  $host = '-',
  $options = undef,
  $order='100'
) {
  $real_interface = $interface ? {
    '' => $name,
    default => $interface,
  }
  shorewall::entry { "routestopped-${order}-${name}":
    line => "${real_interface} ${host} ${options}",
  }
}
