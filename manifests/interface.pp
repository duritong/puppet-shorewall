define shorewall::interface(
    $zone,
    $broadcast = 'detect',
    $options = 'tcpflags,blacklist,routefilter,nosmurfs,logmartians',
    $add_options = '',
    $rfc1918 = false,
    $dhcp = false,
    $order = 100
){
    if $add_options == '' {
      $added_options = ''
    } else {
      $added_options = ",${add_options}"
    }

    if $rfc1918 {
        if $dhcp {
            $options_real = "${options},dhcp"
        } else {
            $options_real = "$options"
        }
    } else {
        if $dhcp {
            $options_real = "${options},norfc1918,dhcp"
        } else {
            $options_real = "${options},norfc1918"
        }
    }

    shorewall::entry { "interfaces.d/${order}-${title}":
        line => "${zone} ${name} ${broadcast} ${options_real}${added_options}",
    }
}

