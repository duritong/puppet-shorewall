define shorewall::entry(
    $line
){
   $target = "/var/lib/puppet/modules/shorewall/${name}"
   $dir = dirname($target)
   file { $target:
        content => "${line}\n",
        mode => 0600, owner => root, group => 0,
        notify => Exec["concat_${dir}"],
    }
}
