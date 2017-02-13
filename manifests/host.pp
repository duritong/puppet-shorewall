define shorewall::host(
    $zone,
    $options = 'tcpflags',
    $order='100'
){
    shorewall::entry{"hosts-${order}-${name}":
        line => "${zone} ${name} ${options}"
    }
}

