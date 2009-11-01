class shorewall::base {
    package { 'shorewall':
        ensure => present,
    }

    # This file has to be managed in place, so shorewall can find it
    file { "/etc/shorewall/shorewall.conf":
      # use OS specific defaults, but use Default if no other is found
      source => [
            "puppet://$server/files/shorewall/${fqdn}/shorewall.conf.$operatingsystem",
            "puppet://$server/files/shorewall/${fqdn}/shorewall.conf",
            "puppet://$server/files/shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
            "puppet://$server/files/shorewall/shorewall.conf.$operatingsystem",
            "puppet://$server/files/shorewall/shorewall.conf",
            "puppet://$server/modules/shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
            "puppet://$server/modules/shorewall/shorewall.conf.$operatingsystem",
            "puppet://$server/modules/shorewall/shorewall.conf.Default"
        ],
        require => Package[shorewall],
        notify => Service[shorewall],
        owner => root, group => 0, mode => 0644;
    }

    service{shorewall:
        ensure  => running,
        enable  => true,
        hasstatus => true,
        hasrestart => true,
        subscribe => [
            Exec["concat_/var/lib/puppet/modules/shorewall/zones"],
            Exec["concat_/var/lib/puppet/modules/shorewall/interfaces"],
            Exec["concat_/var/lib/puppet/modules/shorewall/hosts"],
            Exec["concat_/var/lib/puppet/modules/shorewall/policy"],
            Exec["concat_/var/lib/puppet/modules/shorewall/rules"],
            Exec["concat_/var/lib/puppet/modules/shorewall/masq"],
            Exec["concat_/var/lib/puppet/modules/shorewall/proxyarp"],
            Exec["concat_/var/lib/puppet/modules/shorewall/nat"],
            Exec["concat_/var/lib/puppet/modules/shorewall/blacklist"],
            Exec["concat_/var/lib/puppet/modules/shorewall/rfc1918"],
            Exec["concat_/var/lib/puppet/modules/shorewall/routestopped"],
            Exec["concat_/var/lib/puppet/modules/shorewall/params"]
        ],
        require => Package[shorewall],
    }
}
