# outgoing puppet params
class shorewall::rules::puppet (
  Array[Stdlib::IP::Address]
  $puppetserver,
  Stdlib::Port
  $puppetserver_port = 8140,
  Boolean
  $shorewall6        = true,
) {
  shorewall::params {
    'PUPPETSERVER_PORT':
      value      => $puppetserver_port,
      shorewall6 => $shorewall6;
  }
  $server_ipv4 = $puppetserver.filter |$e| { $e =~ Stdlib::IP::Address::V4::Nosubnet }
  $server_ipv6 = $puppetserver.filter |$e| { $e =~ Stdlib::IP::Address::V6::Nosubnet }
  if !empty($server_ipv4) {
    shorewall::params4 {
      'PUPPETSERVER':
        value => $server_ipv4.join(',');
    }
  }
  if $shorewall6 and !empty($server_ipv6) {
    shorewall::params6 {
      'PUPPETSERVER':
        value => "[${server_ipv6.join('],[')}]";
    }
  }
}
