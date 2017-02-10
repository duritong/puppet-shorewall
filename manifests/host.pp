define shorewall::host(
    $zone,
    $options = 'tcpflags,norfc1918',
    $order='100'
){
    shorewall::entry{"hosts-${order}-${name}":
        line => "${zone} ${name} ${options}"
    }
}

