define shorewall::entry(
    $line
){
  $parts = split($name,'-')
  concat::fragment{$name:
    content => "${line}\n",
    order => $parts[1],
    target => "/etc/shorewall/puppet/${parts[0]}",
  }
}
