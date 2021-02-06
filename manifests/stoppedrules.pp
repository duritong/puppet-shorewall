define shorewall::stoppedrules (
  $action          = 'ACCEPT',
  $source          = '-',
  $destination     = '-',
  $proto           = '-',
  $destinationport = '-',
  $sourceport      = '-',
  $order           = '100'
) {
  shorewall::entry { "stoppedrules-${order}-${name}":
    line => "${action} ${source} ${destination} ${proto} ${destinationport} ${sourceport}",
  }
}
