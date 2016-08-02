# things needed on centos
class shorewall::centos inherits shorewall::base {

  if !$shorewall::conf_source {

    if $::operatingsystemmajrelease > '6' {

      # CentOS 7.x
      augeas{'enable_shorewall_config':
        context => '/files/etc/shorewall/shorewall.conf',
        changes => 'set STARTUP_ENABLED yes',
        lens    => 'Shellvars.lns',
        incl    => '/etc/shorewall/shorewall.conf',
        require => Package['shorewall'],
        notify  => Service['shorewall'],
      }

    } else {

      # Caters for CentOS 5.x, 6.x
      augeas{'enable_shorewall':
        context => '/files/etc/sysconfig/shorewall',
        changes => 'set startup 1',
        lens    => 'Shellvars.lns',
        incl    => '/etc/sysconfig/shorewall',
        require => Package['shorewall'],
        notify  => Service['shorewall'],
      }
    }
  }

}
