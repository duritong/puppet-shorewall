define shorewall::host(
    $zone,
    $options = 'tcpflags,blacklist,norfc1918',
    $order='100'
){
    shorewall::entry{"hosts.d/${order}-${name}":
        line => "${zone} ${name} ${options}"
    }
}

