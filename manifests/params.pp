define shorewall::params($value, $order='100'){
    shorewall::entry{"params.d/${order}-${name}":
        line => "${name}=${value}",
    }
}
