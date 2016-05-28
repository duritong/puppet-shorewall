# a rule section marker
define shorewall::rule_section(
  $order
){
  if $::operatingsystem == 'CentOS' and versioncmp($::operatingsystemmajrelease,'6') > 0 {
    $prefix = '?SECTION'
  } else {
    $prefix = 'SECTION'
  }
  shorewall::entry{"rules-${order}-${name}":
    line => "${prefix} ${name}",
  }
}
