define shorewall::providers(
    $number,
    $mark,
    $duplicate = '-',
    $interface,
    $gateway,
    $options = '-',
    $copy = '',
){
    shorewall::entry { "providers.d/${mark}-${title}":
        line => "${name} ${number} ${mark} ${duplicate} ${interface} ${gateway} ${options} ${copy}",
    }
}
