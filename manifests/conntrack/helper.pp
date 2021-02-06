# Class for managing conntrack file: Helpers
#
# See http://shorewall.net/manpages/shorewall-conntrack.html for more info.
# The $name defines the helper, so this needs to match one of the helpers
# in the documentation.
define shorewall::conntrack::helper (
  $ensure = present,
  $options = undef,
  $source = '-',
  $destination = '-',
  $proto,
  $destinationport,
  $sourceport = undef,
  $user = undef,
  $switch = undef,
  $chain = 'PO',
  $order
) {
  $_helper = sprintf('__%s_HELPER', upcase($name))
  $_chain = ":${chain}"
  $_options = undef

  if ($options != '') {
    $_options = "(${options})"
  }

  shorewall::entry { "conntrack-${order}-${name}":
    ensure => $ensure,
    line   => "?if ${_helper}\nCT:helper:${name}${_options}${_chain} ${source} ${destination} ${proto} ${destinationport} ${sourceport} ${$user} ${switch}\n?endif",
  }
}
