class shorewall::rules::puppet(
  $puppetserver = hiera('shorewall_puppetserver',"puppet.${domain}"),
  $puppetserver_port = hiera('shorewall_puppetserver_port',8140) ,
  $puppetserver_signport = hiera('shorewall_puppetserver_signport',8141) ,
) {
  shorewall::params{
        'PUPPETSERVER':             value => $puppetserver;
        'PUPPETSERVER_PORT':        value => $puppetserver_port;
        'PUPPETSERVER_SIGN_PORT':   value => $puppetserver_signport;
  }
}
