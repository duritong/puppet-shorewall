class shorewall::rules::out::ibackup(
  $backup_host,
  $shorewall4 = true,
  $shorewall6 = false,
){
  shorewall::rule { 'me-net-tcp_backupssh':
    source          => '$FW',
    destination     => "net:${backup_host}",
    proto           => 'tcp',
    destinationport => 'ssh',
    order           => 240,
    action          => 'ACCEPT',
    shorewall4      => $shorewall4,
    shorewall6      => $shorewall6,
  }
}
