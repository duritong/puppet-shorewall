#shorewall::rtrules
define shorewall::rtrules(
    $provider,
    $mark,
    $source = '-',
    $destination = '-',
    $priority = '10000',
){
    shorewall::entry { "rtrules-${mark}-${name}":
        line => "# ${name}\n${source} ${destination} ${provider} ${priority} ${mark}",
    }
}
