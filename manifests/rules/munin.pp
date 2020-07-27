# outgoing munin rules
class shorewall::rules::munin(
  $munin_port       = '4949',
  $munin_collector  = ['127.0.0.1'],
  $munin_collector6 = ['::1'],
  $collector_source = 'net',
  $shorewall6       = true,
){
  shorewall::params{
    'MUNINPORT':
      value      => $munin_port,
      shorewall6 => $shorewall6;
  }
  shorewall::params4{
    'MUNINCOLLECTOR': value => join(Array($munin_collector),',');
  }
  if $shorewall6 {
    shorewall::params6{
      'MUNINCOLLECTOR': value => join(Array($munin_collector6),',');
    }
  }
  shorewall::rule{'net-me-munin-tcp':
    source          => "${collector_source}:\$MUNINCOLLECTOR",
    destination     => '$FW',
    proto           => 'tcp',
    destinationport => '$MUNINPORT',
    order           => 240,
    shorewall6      => $shorewall6,
    action          => 'ACCEPT';
  }
}
