class shorewall::blrules (
  $whitelists,
  $drops,
) {
  file{'/etc/shorewall/puppet/blrules':
    content => template("shorewall/blrules.erb"),
    require => Package['shorewall'],
    notify  => Service['shorewall'],
    owner   => root,
    group   => 0,
    mode    => 0644;
  }
}



