class shorewall::debian inherits shorewall::base {
    case $shorewall_startup {
      '': { $shorewall_startup = 1 }
    }
    file{'/etc/default/shorewall':
        #source => "puppet://$server/modules/shorewall/debian/default",
	content => template("shorewall/debian_default.erb"),
        require => Package['shorewall'],
        notify => Service['shorewall'],
        owner => root, group => 0, mode => 0644;
    }
    Service['shorewall']{
        status => '/sbin/shorewall status'
    }
}
