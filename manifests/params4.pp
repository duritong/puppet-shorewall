# manage a shorewall param, only for ipv4
# http://www.shorewall.net/manpages/shorewall-params.html
define shorewall::params4(
  $value,
  $key   = $name,
  $order ='100',
){
  shorewall::params{
    $name:
      key        => $key,
      value      => $value,
      order      => $order,
      shorewall  => true,
      shorewall6 => false,
  }
}
