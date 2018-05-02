define shorewall::rules::libvirt::host::from_vmz (
  $proto           = '-',
  $destinationport = '-',
  $action          = 'ACCEPT'
) {
  shorewall::rule { $name:
    source          => $shorewall::rules::libvirt::host::vmz,
    destination     => '$FW',
    order           => 300,
    proto           => $proto,
    destinationport => $destinationport,
    action          => $action;
  }
}
