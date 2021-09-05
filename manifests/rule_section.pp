# a rule section marker
define shorewall::rule_section(
  $order,
){
  if versioncmp($facts['shorewall_major_version'],'4') > 0 {
    $rule_section_prefix = '?'
  } else {
    $rule_section_prefix = ''
  }

  shorewall::entry{"rules-${order}-${name}":
    line       => "${rule_section_prefix}SECTION ${name}",
    shorewall  => true,
    shorewall6 => true,
  }
}
