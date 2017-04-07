# manage a certain file
define shorewall::managed_file(
  $shorewall6 = false,
) {
  concat{ "/etc/shorewall/puppet/${name}":
    notify  => Exec['shorewall_check'],
    owner   => 'root',
    group   => 'root',
    mode    => '0600';
  }
  concat::fragment {
    "${name}-header":
      source => "puppet:///modules/shorewall/boilerplate/${name}.header",
      target => "/etc/shorewall/puppet/${name}",
      order  => '000';
    "${name}-footer":
      source => "puppet:///modules/shorewall/boilerplate/${name}.footer",
      target => "/etc/shorewall/puppet/${name}",
      order  => '999';
  }
  if $shorewall6 and $shorewall::with_shorewall6 {
    concat{ "/etc/shorewall6/puppet/${name}":
      notify  => Exec['shorewall6_check'],
      owner   => 'root',
      group   => 'root',
      mode    => '0600';
    }
    concat::fragment {
      "6${name}-header":
        source => "puppet:///modules/shorewall/boilerplate6/${name}.header",
        target => "/etc/shorewall6/puppet/${name}",
        order  => '000';
    }
  }
}
