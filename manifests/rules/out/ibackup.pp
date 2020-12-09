# manage outgoing ssh for backup
class shorewall::rules::out::ibackup(
  Array[Stdlib::IP::Address::Nosubnet] $backup_hosts,
){
  $backup_hosts_ipv4 = $backup_hosts.filter |$e| { $e =~ Stdlib::IP::Address::V4::Nosubnet }
  $backup_hosts_ipv6 = $backup_hosts.filter |$e| { $e =~ Stdlib::IP::Address::V6::Nosubnet }

  if !empty($backup_hosts_ipv4) {
    shorewall::params4{
      'IBACKUP_HOST': value => "${backup_hosts_ipv4.join(',')}",
    }
  }

  if !empty($backup_hosts_ipv6) {
    shorewall::params6{
      'IBACKUP_HOST': value => "[${backup_hosts_ipv6.join('],[')}]",
    }
  }

  shorewall::rule { 'me-net-tcp_backupssh':
    source          => '$FW',
    destination     => 'net:$IBACKUP_HOST',
    proto           => 'tcp',
    destinationport => 'ssh',
    order           => 240,
    action          => 'ACCEPT',
    shorewall       => !empty($backup_hosts_ipv4),
    shorewall6      => !empty($backup_hosts_ipv6),
  }
}
