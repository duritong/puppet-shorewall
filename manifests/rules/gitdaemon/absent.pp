class shorewall::rules::gitdaemon::absent inherit shorewall::rules::gitdaemon {
  Shorewall::Rule['net-me-tcp_gitdaemon']{
    ensure => absent,
  }
}
