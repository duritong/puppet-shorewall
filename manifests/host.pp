define shorewall::host(
    $zone,
    $host,
    $options = 'tcpflags,blacklist,norfc1918',
    $order='100'
){
    shorewall::entry{"hosts-${order}-${name}":
        line => "#${name}\n${zone} ${host} ${options}"
    }
}

