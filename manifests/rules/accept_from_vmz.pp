# accept traffic from libvirt interface
define shorewall::rules::accept_from_vmz (
  $source,
  $proto           = '-',
  $destinationport = '-',
  $action          = 'ACCEPT'
) {
  shorewall::rule { $name:
    source          => $source,
    destination     => '$FW',
    order           => 300,
    proto           => $proto,
    destinationport => $destinationport,
    action          => $action;
  }
}
