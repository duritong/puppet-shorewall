class shorewall::centos inherits shorewall::base {
  if $lsbmajdistrelease == '6' {
    # workaround for
    # http://comments.gmane.org/gmane.comp.security.shorewall/26991
    file{'/etc/shorewall/params':
      ensure => link,
      target => '/etc/shorewall/puppet/params',
      before => Service['shorewall'],
      require => File['/etc/shorewall/puppet']
    }
  }
}
