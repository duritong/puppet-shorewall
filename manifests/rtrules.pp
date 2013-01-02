define shorewall::rtrules(
    $source = '-',
    $destination = '-',
    $provider,
    $priority = '10000',
    $mark,
){
    shorewall::entry { "rtrules.d/${mark}-${title}":
        line => "# ${name}\n${source} ${destination} ${provider} ${priority} ${mark}",
    }
}
