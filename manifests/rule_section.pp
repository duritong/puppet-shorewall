# a rule section marker
define shorewall::rule_section(
  $order,
){
  if versioncmp($shorewall_major_version,'5') < 0 {
    $rule_section_prefix = '?'
  } else {
    $rule_section_prefix = ''
  }

  shorewall::entry{"rules-${order}-${name}":
    line => "${rule_section_prefix}SECTION ${name}",
  }
}
