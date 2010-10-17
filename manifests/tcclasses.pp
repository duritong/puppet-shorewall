define shorewall::tcclasses(
    $interface,
    $rate,
    $ceil,
    $priority,
    $options = '',
    $order = '1'
){
    shorewall::entry { "tcclasses.d/${order}-${title}":
        line => "# ${name}\n${interface} ${order} ${rate} ${ceil} ${priority} ${options}",
    }
}
