class shorewall::base {
    package { 'shorewall':
        ensure => present,
    }

    # This file has to be managed in place, so shorewall can find it
    file {
      '/etc/shorewall/shorewall.conf':
        # use OS specific defaults, but use Default if no other is found
        source => [
            "puppet:///modules/site-shorewall/${fqdn}/shorewall.conf.${operatingsystem}",
            "puppet:///modules/site-shorewall/${fqdn}/shorewall.conf",
            "puppet:///modules/site-shorewall/shorewall.conf.${operatingsystem}.${lsbdistcodename}",
            "puppet:///modules/site-shorewall/shorewall.conf.${operatingsystem}",
            "puppet:///modules/site-shorewall/shorewall.conf",
            "puppet:///modules/shorewall/shorewall.conf.${operatingsystem}.${lsbdistcodename}",
            "puppet:///modules/shorewall/shorewall.conf.${operatingsystem}.${lsbmajdistrelease}",
            "puppet:///modules/shorewall/shorewall.conf.${operatingsystem}",
            "puppet:///modules/shorewall/shorewall.conf"
        ],
        require => Package[shorewall],
        notify => Service[shorewall],
        owner => root, group => 0, mode => 0644;
      '/etc/shorewall/puppet':
        ensure => directory,
        require => Package[shorewall],
        owner => root, group => 0, mode => 0644;
    }

    service{shorewall:
        ensure  => running,
        enable  => true,
        hasstatus => true,
        hasrestart => true,
        require => Package[shorewall],
    }
}
