# a nice wrapper to make hiera config
# a bit easier
define shorewall::config_settings (
  $settings,
) {
  shorewall::config_setting {
    $name:
      value => $settings[$name],
  }
}
