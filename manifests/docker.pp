# manage docker relevant entries
# as mentioned on http://www.shorewall.net/Docker.html
class shorewall::docker {
  shorewall::config_setting {
    'DOCKER':
      value => 'yes',
  }

  shorewall::zone{
    'dock':
      type => 'ipv4'
  }

  shorewall::policy{
    'dock-to-FW':
      sourcezone      => 'dock',
      destinationzone => '$FW',
      policy          => 'REJECT',
      order           => '200';
    'dock-to-all':
      sourcezone      => 'dock',
      destinationzone => 'all',
      policy          => 'ACCEPT',
      order           => '210';
  }

  shorewall::interface{
    'docker0':
      zone    => 'dock',
      options => 'bridge',
      rfc1918 => true,
  }
}
