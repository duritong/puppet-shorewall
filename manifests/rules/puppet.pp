# outgoing puppet params
class shorewall::rules::puppet(
  $puppetserver          = "puppet.${::domain}",
  $puppetserver_v6       = undef,
  $puppetserver_port     = 8140,
  $puppetserver_signport = 8141
){
  shorewall::params{
    'PUPPETSERVER_PORT':        value => $puppetserver_port;
    'PUPPETSERVER_SIGN_PORT':   value => $puppetserver_signport;
  }
  if is_ipv4_address($puppetserver){
    shorewall::params4{
      'PUPPETSERVER': value => $puppetserver;
    }
    if $puppetserver_v6 {
      shorewall::params6{
        'PUPPETSERVER': value => $puppetserver;
      }
    }
  } elsif is_ipv6_address($puppetserver){
    shorewall::params6{
      'PUPPETSERVER': value => $puppetserver;
    }
  } else {
    shorewall::params{
      'PUPPETSERVER': value => $puppetserver;
    }
  }
}
