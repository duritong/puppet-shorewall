define shorewall::rules::torify::non_torified_user() {

  $user = $name

  $whitelist_rule = "allow-from-user=${user}"
  shorewall::rule {
    "$whitelist_rule":
      source      => '$FW',
      destination => 'all',
      user        => $user,
      order       => 101,
      action      => 'ACCEPT';
  }

  $nonat_rule = "dont-redirect-to-tor-user=${user}"
  shorewall::rule {
    "$nonat_rule":
      source       => '$FW',
      destination  => '-',
      user         => $user,
      order        => 106,
      action       => 'NONAT';
  }

}
