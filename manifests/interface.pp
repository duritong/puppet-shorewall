define shorewall::interface(
    $zone,
    $broadcast = 'detect',
    $options = 'tcpflags,blacklist,routefilter,nosmurfs,logmartians',
    $rfc1918 = false,
    $dhcp = false,
    $order = 100
){
    if $rfc1918 {
        if $dhcp {
            $options_real = "${options},dhcp"
        } else {
            $options_real = $options
        }
    } else {
        if $dhcp {
            $options_real = "${options},norfc1918,dhcp"
        } else {
            $options_real = "${options},norfc1918"
        }
    }

    shorewall::entry { "interfaces.d/${order}-${title}":
        line => "${zone} ${name} ${broadcast} ${options_real}",
    }
}

