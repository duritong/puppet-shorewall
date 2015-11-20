# base things for shorewall
class shorewall::base {

  package { 'shorewall':
    ensure => $shorewall::ensure_version,
  }

  # This file has to be managed in place, so shorewall can find it
  file {
    '/etc/shorewall/shorewall.conf':
      require => Package['shorewall'],
      notify  => Exec['shorewall_check'],
      owner   => 'root',
      group   => 'root',
      mode    => '0644';
    '/etc/shorewall/puppet':
      ensure  => directory,
      require => Package['shorewall'],
      owner   => 'root',
      group   => 'root',
      mode    => '0644';
  }

  if $shorewall::conf_source {
    File['/etc/shorewall/shorewall.conf']{
      source => $shorewall::conf_source,
    }
  } else {

    Class['augeas'] -> Class['shorewall::base']

    augeas { 'shorewall_module_config_path':
      changes => 'set /files/etc/shorewall/shorewall.conf/CONFIG_PATH \'"/etc/shorewall/puppet:/etc/shorewall:/usr/share/shorewall"\'',
      lens    => 'Shellvars.lns',
      incl    => '/etc/shorewall/shorewall.conf',
      notify  => Exec['shorewall_check'],
      require => Package['shorewall'];
    }
  }

  exec{'shorewall_check':
    command     => 'shorewall check',
    refreshonly => true,
    notify      => Service['shorewall'],
  }
  service{'shorewall':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['shorewall'],
  }
}
