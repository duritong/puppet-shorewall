# outgoing munin rules
class shorewall::rules::munin (
  Stdlib::Port $munin_port = 4949,
  Array[Stdlib::IP::Address::V4::Nosubnet] $munin_collector = ['127.0.0.1'],
  Array[Stdlib::IP::Address::V6::Nosubnet] $munin_collector6 = ['::1'],
  Array[String[1]] $collector_source = ['net'],
  Boolean $shorewall6 = true,
) {
  shorewall::params {
    'MUNINPORT':
      value      => $munin_port,
      shorewall6 => $shorewall6;
  }
  shorewall::params4 {
    'MUNINCOLLECTOR': value => join(Array($munin_collector),',');
  }
  if $shorewall6 {
    shorewall::params6 {
      'MUNINCOLLECTOR': value => "[${join(Array($munin_collector6),']/128,[')}]/128";
    }
  }
  $collector_source.each |$src| {
    shorewall::rule { "${src}-me-munin-tcp":
      source          => "${src}:\$MUNINCOLLECTOR",
      destination     => '$FW',
      proto           => 'tcp',
      destinationport => '$MUNINPORT',
      order           => 240,
      shorewall6      => $shorewall6,
      action          => 'ACCEPT';
    }
  }
}
