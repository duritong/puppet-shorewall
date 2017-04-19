# things needed on centos
class shorewall::centos inherits shorewall::base {
  if $::operatingsystemmajrelease == '6' {
    augeas{'enable_shorewall':
      context => '/files/etc/sysconfig/shorewall',
      changes => 'set startup 1',
      lens    => 'Shellvars.lns',
      incl    => '/etc/sysconfig/shorewall',
      require => Package['shorewall'],
      notify  => Exec['shorewall_check'],
    }
    if $::operatingsystemmajrelease > 6 {
      augeas{'enable_shorewall_config':
        context => '/files/etc/shorewall/shorewall.conf',
        changes => 'set STARTUP_ENABLED yes',
        lens    => 'Shellvars.lns',
        incl    => '/etc/shorewall/shorewall.conf',
        require => Package['shorewall'],
        notify  => Service['shorewall'],
      }
    }
  }
}
