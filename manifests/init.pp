# Manage shorewall on your system
class shorewall(
  $startup                    = true,
  $conf_source                = false,
  $settings                   = {
    'LOG_MARTIANS' => 'No',
    'DISABLE_IPV6' => 'Yes',
  },
  $ensure_version             = 'present',
  $tor_transparent_proxy_host = '127.0.0.1',
  $tor_transparent_proxy_port = '9040',
  $tor_user                   = $::operatingsystem ? {
    'Debian' => 'debian-tor',
    default  => 'tor'
  },
  $zones                      = {},
  $zones_defaults             = {},
  $interfaces                 = {},
  $interfaces_defaults        = {},
  $hosts                      = {},
  $hosts_defaults             = {},
  $policy                     = {},
  $policy_defaults            = {},
  $rules                      = {},
  $rules_defaults             = {},
  $rulesections               = {},
  $rulesections_defaults      = {},
  $masq                       = {},
  $masq_defaults              = {},
  $proxyarp                   = {},
  $proxyarp_defaults          = {},
  $nat                        = {},
  $nat_defaults               = {},
  $routestopped               = {},
  $routestopped_defaults      = {},
  $stoppedrules               = {},
  $stoppedrules_defaults      = {},
  $params                     = {},
  $params_defaults            = {},
  $tcdevices                  = {},
  $tcdevices_defaults         = {},
  $tcrules                    = {},
  $tcrules_defaults           = {},
  $tcclasses                  = {},
  $tcclasses_defaults         = {},
  $tunnels                    = {},
  $tunnels_defaults           = {},
  $rtrules                    = {},
  $rtrules_defaults           = {},
  $daily_check                = true,
) {

  case $::operatingsystem {
    'Gentoo': { include ::shorewall::gentoo }
    'Debian','Ubuntu': { include ::shorewall::debian }
    'CentOS': { include ::shorewall::centos }
    default: {
      notice "unknown operatingsystem: ${::operatingsystem}"
      include ::shorewall::base
    }
  }

  shorewall::managed_file{
    [
      # See http://www.shorewall.net/manpages/shorewall-zones.html
      'zones',
      # See http://www.shorewall.net/manpages/shorewall-interfaces.html
      'interfaces',
      # See http://www.shorewall.net/manpages/shorewall-hosts.html
      'hosts',
      # See http://www.shorewall.net/manpages/shorewall-policy.html
      'policy',
      # See http://www.shorewall.net/manpages/shorewall-rules.html
      'rules',
      # See http://www.shorewall.net/manpages/shorewall-masq.html
      'masq',
      # See http://www.shorewall.net/manpages/shorewall-proxyarp.html
      'proxyarp',
      # See http://www.shorewall.net/manpages/shorewall-nat.html
      'nat',
      # See http://www.shorewall.net/manpages/shorewall-stoppedrules.html
      'stoppedrules',
      # Deprecated http://www.shorewall.net/4.2/manpages/shorewall-routestopped.html
      'routestopped',
      # See http://www.shorewall.net/manpages/shorewall-params.html
      'params',
      # See http://www.shorewall.net/manpages/shorewall-tcdevices.html
      'tcdevices',
      # Deprecated http://www.shorewall.net/4.6/manpages/shorewall-tcrules.htmle 
      'tcrules',
      # See http://www.shorewall.net/manpages/shorewall-tcclasses.html
      'tcclasses',
      # See http://www.shorewall.net/manpages/shorewall-providers.html
      'providers',
      # See http://www.shorewall.net/manpages/shorewall-tunnels.html
      'tunnel',
      # See http://www.shorewall.net/manpages/shorewall-rtrules.html
      'rtrules',
      # See http://shorewall.net/manpages/shorewall-conntrack.html
      'conntrack',
      # See http://www.shorewall.net/manpages/shorewall-mangle.html
      'mangle',
    ]:;
  }

  create_resources('shorewall::zone',$zones,$zones_defaults)
  create_resources('shorewall::interface',$interfaces,$interfaces_defaults)
  create_resources('shorewall::host',$hosts,$hosts_defaults)
  create_resources('shorewall::policy',$policy,$policy_defaults)
  create_resources('shorewall::rule',$rules,$rules_defaults)
  create_resources('shorewall::rule_section',$rulesections,$rulesections_defaults)
  create_resources('shorewall::masq',$masq,$masq_defaults)
  create_resources('shorewall::proxyarp',$proxyarp,$proxyarp_defaults)
  create_resources('shorewall::nat',$nat,$nat_defaults)
  create_resources('shorewall::stoppedrules',$stoppedrules,
    $stoppedrules_defaults)
  create_resources('shorewall::routestopped',$routestopped,
    $routestopped_defaults)
  create_resources('shorewall::params',$params,$params_defaults)
  create_resources('shorewall::tcdevices',$tcdevices,$tcdevices_defaults)
  create_resources('shorewall::tcrules',$tcrules,$tcrules_defaults)
  create_resources('shorewall::tcclasses',$tcclasses,$tcclasses_defaults)
  create_resources('shorewall::tunnel',$tunnels,$tunnels_defaults)
  create_resources('shorewall::rtrules',$rtrules,$rtrules_defaults)
}
