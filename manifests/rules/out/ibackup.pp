class shorewall::rules::out::ibackup(
  $backup_host,
  $shorewall  = true,
  $shorewall6 = false,
){
  shorewall::rule { 'me-net-tcp_backupssh':
    source          => '$FW',
    destination     => "net:${backup_host}",
    proto           => 'tcp',
    destinationport => 'ssh',
    order           => 240,
    action          => 'ACCEPT',
    shorewall       => $shorewall,
    shorewall6      => $shorewall6,
  }
}
