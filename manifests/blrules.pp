# Manage blrules. For additional information type "man shorewall-blrules"
#
# Sample Usage:
#
#  shorewall::interface { 'br0':
#    zone    => 'net',
#    rfc1918  => true,
#    options => 'tcpflags,blacklist,nosmurfs,routeback,bridge';
#  }
#
#  class { 'shorewall::blrules':
#    options         => 'tcpflags,blacklist,nosmurfs,routeback,bridge',
#    whitelists    =>  [
#                          "net:10.0.0.1,192.168.0.1 all",
#                        ],
#
#    drops           => [
#                          'net  all tcp 22', #ssh
#                       ],
#  }
#
class shorewall::blrules (
  $whitelists,
  $drops,
) {
  file{'/etc/shorewall/puppet/blrules':
    content => template('shorewall/blrules.erb'),
    require => Package['shorewall'],
    notify  => Service['shorewall'],
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
}
