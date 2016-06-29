define shorewall::rule_section(
    $order
){
  $rule_section_prefix = $shorewall_major_version ? {
    '5' => '?'
  }

    shorewall::entry{"rules-${order}-${name}":
        line => "${rule_section_prefix}SECTION ${name}",
    }       
}
