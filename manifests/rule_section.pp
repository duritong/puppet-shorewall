# a rule section marker
define shorewall::rule_section (
  $order,
) {
  if versioncmp($shorewall_version,'4.6.0') > 0 {
    $rule_section_prefix = '?'
  } else {
    $rule_section_prefix = undef
  }

  shorewall::entry { "rules-${order}-${name}":
    line       => "${rule_section_prefix}SECTION ${name}",
    shorewall  => true,
    shorewall6 => true,
  }
}
