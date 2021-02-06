# set a particular config option
#
#  e.g.
#  shorewall::config_setting{
#    'CONFIG_PATH':
#      value => '"/etc/shorewall/puppet:/etc/shorewall:/usr/share/shorewall"'
#  }
define shorewall::config_setting (
  $value,
) {
  augeas { "shorewall_module_${name}":
    changes => "set /files/etc/shorewall/shorewall.conf/${name} ${value}",
    lens    => 'Shellvars.lns',
    incl    => '/etc/shorewall/shorewall.conf',
    notify  => Exec['shorewall_check'],
    require => Package['shorewall'];
  }
}
