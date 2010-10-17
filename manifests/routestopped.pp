define shorewall::routestopped(
    $interface = '',
    $host = '-',
    $options = '',
    $order='100'
){
    $real_interface = $interface ? { 
        '' => $name,
        default => $interface,
    }   
    shorewall::entry{"routestopped.d/${order}-${title}":
        line => "${real_interface} ${host} ${options}",
    }           
}
