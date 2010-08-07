define shorewall::managed_file () {
    $dir = "/var/lib/puppet/modules/shorewall/${name}.d"
    concatenated_file { "/var/lib/puppet/modules/shorewall/$name":
        dir => $dir,
        mode => 0600,
    }       
    file {
        "${dir}/000-header":
            source => "puppet:///modules/shorewall/boilerplate/${name}.header",
            mode => 0600, owner => root, group => 0,
            notify => Exec["concat_${dir}"];
        "${dir}/999-footer":
            source => "puppet:///modules/shorewall/boilerplate/${name}.footer",
            mode => 0600, owner => root, group => 0,
            notify => Exec["concat_${dir}"];
    }       
} 
