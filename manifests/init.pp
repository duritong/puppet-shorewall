modules_dir { "shorewall": }

class shorewall { 

    case $operatingsystem {
        gentoo: { include shorewall::gentoo }
        debian: { include shorewall::debian }
        default: { include shorewall::base }
    }

    file {"/var/lib/puppet/modules/shorewall":
        ensure => directory,
        force => true,
        owner => root, group => 0, mode => 0755; 
    }

    # See http://www.shorewall.net/3.0/Documentation.htm#Zones
    shorewall::managed_file{ zones: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Interfaces
    shorewall::managed_file{ interfaces: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Hosts
    shorewall::managed_file { hosts: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Policy
    shorewall::managed_file { policy: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Rules
    shorewall::managed_file { rules: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Masq
    shorewall::managed_file{ masq: }
    # See http://www.shorewall.net/3.0/Documentation.htm#ProxyArp
    shorewall::managed_file { proxyarp: }
    # See http://www.shorewall.net/3.0/Documentation.htm#NAT
    shorewall::managed_file { nat: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Blacklist
    shorewall::managed_file { blacklist: }
    # See http://www.shorewall.net/3.0/Documentation.htm#rfc1918
    shorewall::managed_file { rfc1918: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Routestopped
    shorewall::managed_file { routestopped: }
    # See http://www.shorewall.net/3.0/Documentation.htm#Variables 
    shorewall::managed_file { params: }
}
