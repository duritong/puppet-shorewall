define shorewall::nat(
    $interface,
    $internal,
    $all = 'no',
    $local = 'yes',
    $order='100'
){
    shorewall::entry{"nat.d/${order}-${title}":
        line => "${name} ${interface} ${internal} ${all} ${local}"
    }           
}
