# outgoing rsyslog traffic
class shorewall::rules::out::rsyslog (
  Array[Stdlib::IP::Address] $server,
  Stdlib::Port $port = 20514,
  Boolean $shorewall6 = true,
) {
  $server_ipv4 = $server.filter |$e| { $e =~ Stdlib::IP::Address::V4::Nosubnet }
  $server_ipv6 = $server.filter |$e| { $e =~ Stdlib::IP::Address::V6::Nosubnet }
  if !empty($server_ipv4) {
    shorewall::params4 {
      'RSYSLOG_SERVER':
        value => $server_ipv4.join(',');
    }
  }
  if $shorewall6 and !empty($server_ipv6) {
    shorewall::params6 {
      'RSYSLOG_SERVER':
        value => "[${server_ipv6.join('],[')}]";
    }
  }
  # we want to connect to the puppet server
  shorewall::rule { 'me-net-rsyslog_tcp':
    source          => '$FW',
    destination     => 'net:$RSYSLOG_SERVER',
    proto           => 'tcp',
    destinationport => $port,
    order           => 340,
    shorewall6      => $shorewall6,
    action          => 'ACCEPT';
  }
}
