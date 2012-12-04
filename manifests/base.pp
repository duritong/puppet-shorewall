class shorewall::base {
    package { 'shorewall':
        ensure => $shorewall_ensure_version,
    }

    # This file has to be managed in place, so shorewall can find it
    file {
      '/etc/shorewall/shorewall.conf':
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
