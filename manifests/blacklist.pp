define shorewall::blacklist(
    $proto = '-',
    $port = '-',
    $order='100'
){
    shorewall::entry{"blacklist.d/${order}-${title}":
        line => "${name} ${proto} ${port}",
    }           
}
