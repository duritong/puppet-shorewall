class shorewall::debian inherits shorewall::base {
  file{'/etc/default/shorewall':
    content => template("shorewall/debian_default.erb"),
    require => Package['shorewall'],
    notify => Service['shorewall'],
    owner => 'root', group => 'root', mode => '0644';
  }
  Service['shorewall']{
    status => '/sbin/shorewall status'
  }
}
