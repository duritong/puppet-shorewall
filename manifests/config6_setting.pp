# set a particular config option for shorewall6
#
#  e.g.
#  shorewall::config6_setting{
#    'CONFIG_PATH':
#      value => '"/etc/shorewall6/puppet:/etc/shorewall6:/usr/share/shorewall6"'
#  }
define shorewall::config6_setting(
  $value,
){
  augeas { "shorewall6_module_${name}":
    changes => "set /files/etc/shorewall6/shorewall6.conf/${name} ${value}",
    lens    => 'Shellvars.lns',
    incl    => '/etc/shorewall6/shorewall6.conf',
    notify  => Exec['shorewall6_check'],
    require => Package['shorewall6'];
  }
}
