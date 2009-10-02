class shorewall::rules::puppet {
  case $shorewall_puppetserver {
    '': { $shorewall_puppetserver = "puppet.${domain}" } 
  }
  case $shorewall_puppetserver_port {
    '': { $shorewall_puppetserver_port = '8140' }
  }
  case $shorewall_puppetserver_signport {
    '': { $shorewall_puppetserver_signport = '8141' }
  }
  shorewall::params{
        'PUPPETSERVER':             value => $shorewall_puppetserver;
        'PUPPETSERVER_PORT':        value => $shorewall_puppetserver_port;
        'PUPPETSERVER_SIGN_PORT':   value => $shorewall_puppetserver_signport;
  }
}
