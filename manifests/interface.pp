define shorewall::interface(
    $zone,
    $broadcast = 'detect',
    $options = 'tcpflags,routefilter,nosmurfs,logmartians',
    $add_options = '',
    $dhcp = false,
    $order = 100
){
    $added_opts = $add_options ? {
        ''      => '',
        default => ",${add_options}",
    }

    $dhcp_opt = $dhcp ? {
        false   => '',
        default => ',dhcp',
    }

    shorewall::entry { "interfaces-${order}-${name}":
        line => "${zone} ${name} ${broadcast} ${options}${dhcp_opt}${added_opts}",
    }
}

