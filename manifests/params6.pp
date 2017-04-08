# manage a shorewall param, only for ipv6
# http://www.shorewall.net/manpages6/shorewall6-params.html
define shorewall::params6(
  $value,
  $key   = $name,
  $order ='100',
){
  shorewall::params{
    $name:
      key        => $key,
      value      => $value,
      order      => $order,
      shorewall  => false,
      shorewall6 => true,
  }
}
