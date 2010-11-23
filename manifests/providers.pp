define shorewall::providers(
    $provider,
    $number = '',
    $mark = '',
    $duplicate = 'main',
    $interface = '',
    $gateway = '',
    $options = '',
    $copy = '',
    $order='100'
){
    shorewall::entry{"providers.d/${order}-${name}":
        line => "# ${name}\n${provider} ${number} ${mark} ${duplicate} ${interface} ${gateway} ${options} ${copy}"
    }
}

