# outgoing munin rules
class shorewall::rules::munin(
  $munin_port       = '4949',
  $munin_collector  = ['127.0.0.1'],
  $collector_source = 'net'
){
  shorewall::params4{
    'MUNINPORT': value => $munin_port;
    'MUNINCOLLECTOR': value => join(any2array($munin_collector),',');
  }
  shorewall::rule{'net-me-munin-tcp':
    source          => "${collector_source}:\$MUNINCOLLECTOR",
    destination     => '$FW',
    proto           => 'tcp',
    destinationport => '$MUNINPORT',
    order           => 240,
    action          => 'ACCEPT';
  }
}
