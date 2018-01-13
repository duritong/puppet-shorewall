# manage a shorewall param, will be used for both
# ipv4 and ipv6 if not specified differently using
# shorewall or shorwall6 booleans.
# http://www.shorewall.net/manpages/shorewall-params.html
# http://www.shorewall.net/manpages6/shorewall6-params.html
define shorewall::params(
  $value,
  $key        = $name,
  $order      ='100',
  $shorewall  = true,
  $shorewall6 = true,
){
  $with_shorewall6 = $shorewall6 and $shorewall::with_shorewall6
  shorewall::entry{"params-${order}-${name}":
    line       => "${key}=${value}",
    shorewall  => $shorewall,
    shorewall6 => $with_shorewall6,
  }
}
