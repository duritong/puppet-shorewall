# http://www.shorewall.net/manpages/shorewall-policy.html
# http://www.shorewall.net/manpages6/shorewall6-policy.html
define shorewall::policy (
  $sourcezone,
  $destinationzone,
  $policy,
  $order,
  $shloglevel = '-',
  $limitburst = '-',
  $shorewall  = true,
  $shorewall6 = true,
) {
  $with_shorewall6 = $shorewall6 and $shorewall::with_shorewall6
  shorewall::entry { "policy-${order}-${name}":
    line       => "# ${name}\n${sourcezone} ${destinationzone} ${policy} ${shloglevel} ${limitburst}",
    shorewall  => $shorewall,
    shorewall6 => $with_shorewall6,
  }
}
