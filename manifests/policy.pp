define shorewall::policy(
    $sourcezone,
    $destinationzone,
    $policy, $shloglevel = '-',
    $limitburst = '-',
    $order
){
    shorewall::entry{"policy.d/${order}-${title}":
        line => "# ${name}\n${sourcezone} ${destinationzone} ${policy} ${shloglevel} ${limitburst}",
    }
}

