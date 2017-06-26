# Class for managing conntrack file: Helpers
#
# See http://shorewall.net/manpages/shorewall-conntrack.html for more info.
# The $name defines the helper, so this needs to match one of the helpers
# in the documentation.
define shorewall::conntrack::helper(
  $options = '',
  $source = '-',
  $destination = '-',
  $proto,
  $destinationport,
  $sourceport = '',
  $user = '',
  $switch = '',
  $chain = 'PO',
  $order
) {

  $_helper = sprintf("__%s_HELPER", upcase($name))
  $_chain = ":${chain}"
  $_options = ''

  if ($options != '') {
    $_options = "(${options})"
  }

  shorewall::entry{"conntrack-${order}-${name}":
    line => "?if ${_helper}\nCT:helper:${name}${_options}${_chain} ${source} ${destination} ${proto} ${destinationport} ${sourceport} ${$user} ${switch}\n?endif"
  }
}
