# http://www.shorewall.net/manpages/shorewall-policy.html
define shorewall::policy4(
  $sourcezone,
  $destinationzone,
  $policy,
  $order,
  $shloglevel = '-',
  $limitburst = '-',
){
  shorewall::policy{
    $name:
      sourcezone      => $sourcezone,
      destinationzone => $destinationzone,
      policy          => $policy,
      order           => $order,
      shloglevel      => $shloglevel,
      limitburst      => $limitburst,
      shorewall       => true,
      shorewall6      => false,
  }
}

