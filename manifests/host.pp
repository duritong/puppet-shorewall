define shorewall::host(
    $zone,
    $host = undef,
    $options = 'tcpflags,blacklist,norfc1918',
    $order ='100'
){
    
    unless $host == undef {
      $host = $name
    }

    shorewall::entry{"hosts-${order}-${name}":
        line => "#${name}\n${zone} ${host} ${options}"
    }
}
