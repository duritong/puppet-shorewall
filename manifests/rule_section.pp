define shorewall::rule_section(
    $order
){
    shorewall::entry{"rules.d/${order}-${title}":
        line => "SECTION ${name}",
    }       
}
