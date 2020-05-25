define shorewall::snat(
  $action,
  $dest,
  $source  = '-',
  $proto   = '-',
  $port    = '-',
  $ipsec   = '-',
  $mark    = '-',
  $order   = '100',
){
  shorewall::entry{"snat-${order}-${name}":
    line => "# ${name}\n${action} ${source} ${dest} ${proto} ${port} ${ipsec} ${mark}"
  }
}

