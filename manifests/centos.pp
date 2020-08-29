# things needed on centos
class shorewall::centos inherits shorewall::base {
  if ($facts['os']['name'] == 'CentOS') and versioncmp($facts['os']['release']['major'],'7') < 0 {
    augeas{'enable_shorewall':
      context => '/files/etc/sysconfig/shorewall',
      changes => 'set startup 1',
      lens    => 'Shellvars.lns',
      incl    => '/etc/sysconfig/shorewall',
      require => Package['shorewall'],
      notify  => Exec['shorewall_check'],
    }
    if $shorewall::with_shorewall6 {
      package{'perl-Socket6':
        ensure => 'installed',
        before => Package['shorewall6'],
      }
    }
  }
  if ($facts['os']['name'] == 'CentOS') and versioncmp($facts['os']['release']['major'],'7') > 0 {
    fail('We do not support that module on EL > 7 - Consider switching to nftables')
  }
}
