define shorewall::tcdevices (
  $in_bandwidth,
  $out_bandwidth,
  $options = undef,
  $redirected_interfaces = undef,
  $order = '100'
) {
  shorewall::entry { "tcdevices-${order}-${name}":
    line => "${name} ${in_bandwidth} ${out_bandwidth} ${options} ${redirected_interfaces}",
  }
}
