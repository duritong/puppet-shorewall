define shorewall::entry(
    $ensure = present,
    $line
){
   $target = "/var/lib/puppet/modules/shorewall/${name}"
   $dir = dirname($target)
   file { $target:
        ensure => $ensure,
        content => "${line}\n",
        mode => 0600, owner => root, group => 0,
        notify => Exec["concat_${dir}"],
    }
}
