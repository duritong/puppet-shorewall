define shorewall::policy(
    $sourcezone,
    $destinationzone,
    $policy, $shloglevel = '-',
    $limitburst = '-',
    $order
){
    shorewall::entry{"policy.d/${order}-${name}":
        line => "# ${name}\n${sourcezone} ${destinationzone} ${policy} ${shloglevel} ${limitburst}",
    }
}

