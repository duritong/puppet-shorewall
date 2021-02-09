# shorewall rules for a libvirt host
class shorewall::rules::libvirt::host (
  $vmz           = 'vmz',
  $snat_iface    = $facts['networking']['primary'],
  $debproxy_port = 8000,
  $accept_dhcp   = true,
  $vmz_iface     = 'virbr0',
) {
  shorewall::policy {
    'fw-to-vmz':
      sourcezone      => '$FW',
      destinationzone => $vmz,
      policy          => 'ACCEPT',
      order           => 110;
    'vmz-to-net':
      sourcezone      => $vmz,
      destinationzone => 'net',
      policy          => 'ACCEPT',
      order           => 200;
    'vmz-to-all':
      sourcezone      => $vmz,
      destinationzone => 'all',
      policy          => 'DROP',
      shloglevel      => 'info',
      order           => 800;
  }

  shorewall::rules::accept_from_vmz {
    default:
      source => $vmz_iface;
    'accept_dns_from_vmz':
      action          => 'DNS(ACCEPT)';
    'accept_tftp_from_vmz':
      action          => 'TFTP(ACCEPT)';
    'accept_puppet_from_vmz':
      proto           => 'tcp',
      destinationport => '8140',
      action          => 'ACCEPT';
  }

  if $accept_dhcp {
    shorewall::mangle { "CHECKSUM:T_${vmz_iface}":
      action          => 'CHECKSUM:T',
      source          => '-',
      destination     => $vmz_iface,
      proto           => 'udp',
      destinationport => '68';
    }
  }

  if $debproxy_port {
    shorewall::rule::accept::from_vmz { 'accept_debproxy_from_vmz':
      proto           => 'tcp',
      destinationport => $debproxy_port,
      action          => 'ACCEPT';
    }
  }

  if $snat_iface {
    shorewall::snat {
      "snat-${snat_iface}":
        action => "SNAT(${facts['networking']['interfaces'][$snat_iface]['ip']})",
        source => '10.0.0.0/8,169.254.0.0/16,172.16.0.0/12,192.168.0.0/16';
    }
  }
}
