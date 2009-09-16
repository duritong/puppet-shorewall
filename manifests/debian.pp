class shorewall::debian inherits shorewall::base {
    file{'/etc/default/shorewall':
        source => "puppet://$server/shorewall/debian/default",
        require => Package['shorewall'],
        notify => Service['shorewall'],
        owner => root, group => 0, mode => 0644;
    }
    Service['shorewall']{
        status => '/sbin/shorewall status'
    }
}
