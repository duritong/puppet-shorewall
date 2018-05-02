define shorewall::host(
    $zone,
    $host,
    $options = 'tcpflags',
    $order='100'
){

    shorewall::entry{"hosts-${order}-${name}":
        line => "#${name}\n${zone} ${host} ${options}"
    }
}
