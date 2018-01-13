# a nice wrapper to make hiera config
# a bit easier
define shorewall::config6_settings(
  $settings,
){
  shorewall::config6_setting{
    $name:
      value => $settings[$name],
  }
}
