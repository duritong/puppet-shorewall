define shorewall::blacklist(
    $proto = '-',
    $port = '-',
    $order='100'
){
    shorewall::entry{"blacklist.d/${order}-${name}":
        line => "${name} ${proto} ${port}",
    }           
}
