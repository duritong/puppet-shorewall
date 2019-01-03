# a wrapper for firewall dnat rules
# setting up rules for IPv4 DNAT
# including hairpinning for the local networks
# according to http://www.shorewall.net/FAQ.htm#faq2
# assumption is that by default
# ext (eth0) -> loc (eth1)
define shorewall::dnat_rule(
  $destination,
  $port,
  $ext_source    = undef,
  $ext_ip4       = undef,
  $local_src_ifs = undef,
  $ext_interface = 'eth0',
  $dest_if       = 'eth1',
  $ext_zone      = 'net',
  $dest_zone     = 'loc',
  $proto         = 'tcp',
){
  $real_ext_source = pick($ext_source, $ext_zone)
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
      source => $real_ext_source;
    "dnat-FW-${name}":
      source => '$FW';
    "hairpin-${name}":
      source => $dest_zone;
  }

  $real_local_src_ifs.each |$li| {
    # network/masklen - CIDR
    $local_net = "${facts['networking']['interfaces'][$li]['network']}/${netmask_to_masklen($facts['networking']['interfaces'][$li]['netmask'])}"
    # exclude the ip of the fw to be masqueraded as well
    if $li == $dest_if {
      $exclude_source = "!${facts['networking']['interfaces'][$destif]['ip']}"
    } else {
      $exclude_source = ''
    }
    $source = "${local_net}${exclude_source}"
    shorewall::snat4{
      "hairpin-${name}-${li}":
        action => "SNAT(${real_ext_ip4})",
        source => $source,
        dest   => "${dest_if}:${destination}",
        proto  => $proto,
        port   => $port,
    }

    shorewall::masq{
      "hairpin-${name}-${li}":
        interface => $li,
        source    => $source,
        address   => $ext_ip4,
        proto     => $proto,
        port      => $port,
    }
  }
}
