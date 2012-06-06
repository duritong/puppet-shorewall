class shorewall::rules::out::ibackup(
  $backup_host = hiera('shorewall_ibackup_host')
) {
    shorewall::rule { 'me-net-tcp_backupssh':
        source          => '$FW',
        destination     => "net:${backup_host}",
        proto           => 'tcp',
        destinationport => 'ssh',
        order           => 240,
        action          => 'ACCEPT';
    }
}
