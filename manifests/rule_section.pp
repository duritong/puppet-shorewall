define shorewall::rule_section(
    $order
){
    shorewall::entry{"rules.d/${order}-${name}":
        line => "SECTION ${name}",
    }       
}
