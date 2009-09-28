class shorewall::rules::http::disable inherits shorewall::http {
  Shorewall::Rule['net-me-http-tcp']{
        action  => 'DROP',
    }
}
