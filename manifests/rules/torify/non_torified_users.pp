class shorewall::rules::torify::non_torified_users {

  $real_non_torified_users = $shorewall::real_non_torified_users

  shorewall::rules::torify::non_torified_user {
    $real_non_torified_users:
  }

}
