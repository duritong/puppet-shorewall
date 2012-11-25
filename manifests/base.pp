class shorewall::base {
    package { 'shorewall':
        ensure => $shorewall_ensure_version,
    }

    # This file has to be managed in place, so shorewall can find it
    file { "/etc/shorewall/shorewall.conf":
      # use OS specific defaults, but use Default if no other is found
      source => [
            "puppet:///modules/site-shorewall/${fqdn}/shorewall.conf.$operatingsystem",
            "puppet:///modules/site-shorewall/${fqdn}/shorewall.conf",
            "puppet:///modules/site-shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
            "puppet:///modules/site-shorewall/shorewall.conf.$operatingsystem",
            "puppet:///modules/site-shorewall/shorewall.conf",
            "puppet:///modules/shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
            "puppet:///modules/shorewall/shorewall.conf.$operatingsystem",
            "puppet:///modules/shorewall/shorewall.conf"
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
            File["/var/lib/puppet/modules/shorewall/zones"],
            File["/var/lib/puppet/modules/shorewall/interfaces"],
            File["/var/lib/puppet/modules/shorewall/hosts"],
            File["/var/lib/puppet/modules/shorewall/policy"],
            File["/var/lib/puppet/modules/shorewall/rules"],
            File["/var/lib/puppet/modules/shorewall/masq"],
            File["/var/lib/puppet/modules/shorewall/proxyarp"],
            File["/var/lib/puppet/modules/shorewall/nat"],
            File["/var/lib/puppet/modules/shorewall/blacklist"],
            File["/var/lib/puppet/modules/shorewall/rfc1918"],
            File["/var/lib/puppet/modules/shorewall/routestopped"],
            File["/var/lib/puppet/modules/shorewall/params"],
            File["/var/lib/puppet/modules/shorewall/tcdevices"],
            File["/var/lib/puppet/modules/shorewall/tcrules"],
            File["/var/lib/puppet/modules/shorewall/tcclasses"],
            File["/var/lib/puppet/modules/shorewall/rtrules"],
            File["/var/lib/puppet/modules/shorewall/providers"],
        ],
        require => Package[shorewall],
    }
}
