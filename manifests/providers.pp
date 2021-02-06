# manage providers
define shorewall::providers (
  $provider   = $name,
  $number     = undef,
  $mark       = undef,
  $duplicate  = 'main',
  $interface  = undef,
  $gateway    = undef,
  $options    = undef,
  $copy       = undef,
  $order      = '100'
) {
  shorewall::entry { "providers-${order}-${name}":
    line => "# ${name}\n${provider} ${number} ${mark} ${duplicate} ${interface} ${gateway} ${options} ${copy}",
  }
}
