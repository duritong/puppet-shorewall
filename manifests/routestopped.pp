define shorewall::routestopped(
    $interface = $name,
    $host = '-',
    $options = '',
    $order='100'
){
    shorewall::entry{"routestopped-${order}-${name}":
        line => "${interface} ${host} ${options}",
    }
}
