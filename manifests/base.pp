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
  if $shorewall::with_shorewall6 {
    package{'shorewall6':
      ensure => 'installed',
    }
    # serialize systemd where it's not yet done
    if (versioncmp($facts['shorewall_version'],'5.1.6') < 0) and (versioncmp($facts['os']['release']['major'],'6') > 0) {
      include ::systemd
      file{
        '/etc/systemd/system/shorewall6.service.d':
          ensure => directory,
          owner  => 'root',
          group  => 'root',
          mode   => '0644';
        '/etc/systemd/system/shorewall6.service.d/after-ipv4.conf':
          content => "[Unit]\nAfter=shorewall.service\n",
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          notify  => Exec['systemctl-daemon-reload'],
      }
      Exec['systemctl-daemon-reload'] -> Service['shorewall6']
    }
    file {
      '/etc/shorewall6/shorewall6.conf':
        require => Package['shorewall6'],
        notify  => Exec['shorewall6_check'],
        owner   => 'root',
        group   => 'root',
        mode    => '0600';
      '/etc/shorewall6/puppet':
        ensure  => directory,
        require => Package['shorewall6'],
        owner   => 'root',
        group   => 'root',
        mode    => '0600';
    }
  }

  if str2bool($shorewall::startup) {
    $startup_str = 'Yes'
  } else {
    $startup_str = 'No'
  }
  if $shorewall::conf_source {
    File['/etc/shorewall/shorewall.conf']{
      source => $shorewall::conf_source,
    }
  } else {
    shorewall::config_setting{
      'CONFIG_PATH':
        value => "\"\${CONFDIR}/shorewall/puppet:\${CONFDIR}/shorewall:\${SHAREDIR}/shorewall\"";
      'STARTUP_ENABLED':
        value => $startup_str;
    }
    $cfs =  keys($shorewall::merged_settings)
    shorewall::config_settings{
      $cfs:
        settings => $shorewall::merged_settings;
    }
  }
  exec{'shorewall_check':
    command     => 'shorewall check',
    refreshonly => true,
    require     => Package['shorewall'],
  } ~> exec{'shorewall_try':
    command     => 'shorewall try /etc/shorewall',
    refreshonly => true,
  } -> service{'shorewall':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  if $shorewall::with_shorewall6 {
    shorewall::config6_setting{
      'CONFIG_PATH':
        value => "\"\${CONFDIR}/shorewall6/puppet:\${CONFDIR}/shorewall6:/usr/share/shorewall6:\${SHAREDIR}/shorewall\"";
      'STARTUP_ENABLED':
        value => $startup_str;
    }
    $cfs6 =  keys($shorewall::settings6)
    shorewall::config6_settings{
      $cfs6:
        settings => $shorewall::settings6;
    }

    exec{'shorewall6_check':
      command     => 'shorewall6 check',
      refreshonly => true,
      require     => Package['shorewall6'],
    } ~> exec{'shorewall6_try':
      command     => 'shorewall6 try /etc/shorewall6',
      refreshonly => true,
    } -> service{'shorewall6':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

  file{'/etc/cron.daily/shorewall_check':}
  if $shorewall::daily_check {
    if $shorewall::with_shorewall6 {
      $shorewall6_check_str = ' && shorewall6 check'
    } else {
      $shorewall6_check_str = ''
    }
    File['/etc/cron.daily/shorewall_check']{
      content => "#!/bin/bash

output=\$((shorewall check${shorewall6_check_str}) 2>&1)
if [ \$? -gt 0 ]; then
  echo 'Error while checking firewall!'
  echo \"\${output}\"
  exit 1
fi
exit 0
",
      owner   => root,
      group   => 0,
      mode    => '0700',
      require => Service['shorewall'],
    }
    if $shorewall::with_shorewall6 {
      Service['shorewall6'] -> File['/etc/cron.daily/shorewall_check']
    }
  } else {
    File['/etc/cron.daily/shorewall_check']{
      ensure => absent,
    }
  }
}
