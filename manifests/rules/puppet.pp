# outgoing puppet params
class shorewall::rules::puppet(
  $puppetserver          = "puppet.${::domain}",
  $puppetserver_v6       = undef,
  $puppetserver_port     = 8140,
  $shorewall6            = true,
){
  shorewall::params{
    'PUPPETSERVER_PORT':
      value      => $puppetserver_port,
      shorewall6 => $shorewall6;
  }
  if ($puppetserver =~ Stdlib::IP::Address::V4){
    shorewall::params4{
      'PUPPETSERVER':
        value => $puppetserver;
    }
    if $puppetserver_v6 {
      shorewall::params6{
        'PUPPETSERVER':
          value => $puppetserver_v6;
      }
    }
  } elsif ($puppetserver =~ Stdlib::IP::Address::V6){
    shorewall::params6{
      'PUPPETSERVER':
        value => $puppetserver;
    }
  } else {
    shorewall::params{
      'PUPPETSERVER':
        value      => $puppetserver,
        shorewall6 => $shorewall6;
    }
  }
}
