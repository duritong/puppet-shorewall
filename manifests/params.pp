define shorewall::params($value, $order='100'){
    shorewall::entry{"params.d/${order}-${title}":
        line => "${name}=${value}",
    }
}
