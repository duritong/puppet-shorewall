# a wrapper for firewall dnat rules
# setting up rules for IPv4 DNAT
# including hairpinning for the local networks
# according to http://www.shorewall.net/FAQ.htm#faq2
# assumption is that by default
# ext (eth0) -> loc (eth1)
define shorewall::dnat_rule(
  $destination,
  $port,
  $dnat_source   = undef,
  $ext_ip4       = undef,
  $local_src_ifs = undef,
  $ext_interface = 'eth0',
  $dest_if       = 'eth1',
  $ext_zone      = 'net',
  $dest_zone     = 'loc',
  $proto         = 'tcp',
){
  $real_dnat_source = pick($dnat_source, $ext_zone)
  $real_ext_ip4 = pick($ext_ip4,$facts['networking']['interfaces'][$ext_interface]['ip'])
  $real_local_src_ifs = pick($local_src_ifs, Array($dest_if))

  shorewall::rule4{
    default:
      destination     => "${dest_zone}:${destination}",
      originaldest    => $real_ext_ip4,
      destinationport => $port,
      proto           => $proto,
      order           => 140,
      action          => 'DNAT';
    "dnat-${name}":
      source => $real_dnat_source;
    "hairpin-${name}":
      source => $dest_zone;
  }

  $real_local_src_ifs.each |$li| {
    # network/masklen - CIDR
    $local_net = "${facts['networking']['interfaces'][$li]['network']}/${netmask_to_masklen($facts['networking']['interfaces'][$li]['netmask'])}"
    shorewall::snat4{
      "hairpin-${name}-${li}":
        action => "SNAT(${real_ext_ip4})",
        source => $local_net,
        dest   => "${dest_if}:${destination}",
        proto  => $proto,
        port   => $port,
    }

    shorewall::masq{
      "hairpin-${name}-${li}":
        interface => $li,
        source    => $local_net,
        address   => $ext_ip4,
        proto     => $proto,
        port      => $port,
    }
  }
}
