# http://www.shorewall.net/manpages6/shorewall6-policy.html
define shorewall::policy6 (
  $sourcezone,
  $destinationzone,
  $policy,
  $order,
  $shloglevel = '-',
  $limitburst = '-',
) {
  shorewall::policy {
    $name:
      sourcezone      => $sourcezone,
      destinationzone => $destinationzone,
      policy          => $policy,
      order           => $order,
      shloglevel      => $shloglevel,
      limitburst      => $limitburst,
      shorewall       => false,
      shorewall6      => true,
  }
}
