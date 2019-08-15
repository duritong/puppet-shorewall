# Manage shorewall on your system
class shorewall(
  $startup                    = true,
  $conf_source                = false,
  $settings                   = {},
  $settings6                  = {},
  $shorewall6                 = 'auto',
  $ensure_version             = 'present',
  $tor_transparent_proxy_host = '127.0.0.1',
  $tor_transparent_proxy_port = '9040',
  $tor_user                   = $facts['operatingsystem'] ? {
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
  $policy4                    = {},
  $policy6                    = {},
  $policy_defaults            = {},
  $rules                      = {},
  $rules4                     = {},
  $rules6                     = {},
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
  $params4                    = {},
  $params6                    = {},
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

  # workaround https://tickets.puppetlabs.com/browse/FACT-1739
  if $shorewall6 == 'auto' {
    if $facts['ipaddress6'] and $facts['ipaddress6'] =~ /:/ {
      $with_shorewall6 = true
    } else {
      $with_shorewall6 = false
    }
  } else {
    $with_shorewall6 = str2bool($shorewall6)
  }

  $disable_ipv6 = $with_shorewall6 ? {
    false   => 'Yes',
    default => 'No',
  }
  $def_settings = {
    'LOG_MARTIANS' => 'No',
    'DISABLE_IPV6' => $disable_ipv6,
  }

  $merged_settings = merge($def_settings,$settings)

  case $facts['operatingsystem'] {
    'Gentoo': { include ::shorewall::gentoo }
    'Debian','Ubuntu': { include ::shorewall::debian }
    'CentOS': { include ::shorewall::centos }
    default: {
      notice "unknown operatingsystem: ${facts['operatingsystem']}"
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
  Shorewall::Managed_file['zones','interfaces','params','rules','policy']{
    shorewall6 => true,
  }

  # shorewall-masq is deprecated and automatically converted
  # to snat rules starting with release 5.2
  # see http://shorewall.org/manpages/shorewall-masq.html
  if (versioncmp($facts['shorewall_version'], '5.2') == -1) {
    shorewall::managed_file { 'masq': }
    create_resources('shorewall::masq',$masq,$masq_defaults)
  }

  create_resources('shorewall::zone',$zones,$zones_defaults)
  create_resources('shorewall::interface',$interfaces,$interfaces_defaults)
  create_resources('shorewall::host',$hosts,$hosts_defaults)
  create_resources('shorewall::policy',$policy,$policy_defaults)
  create_resources('shorewall::policy4',$policy4,$policy_defaults)
  create_resources('shorewall::policy6',$policy6,$policy_defaults)
  create_resources('shorewall::rule',$rules,$rules_defaults)
  create_resources('shorewall::rule4',$rules4,$rules_defaults)
  create_resources('shorewall::rule6',$rules6,$rules_defaults)
  create_resources('shorewall::rule_section',$rulesections,$rulesections_defaults)
  create_resources('shorewall::proxyarp',$proxyarp,$proxyarp_defaults)
  create_resources('shorewall::nat',$nat,$nat_defaults)
  create_resources('shorewall::stoppedrules',$stoppedrules,
    $stoppedrules_defaults)
  create_resources('shorewall::routestopped',$routestopped,
    $routestopped_defaults)
  create_resources('shorewall::params',$params,$params_defaults)
  create_resources('shorewall::params4',$params4,$params_defaults)
  create_resources('shorewall::params6',$params6,$params_defaults)
  create_resources('shorewall::tcdevices',$tcdevices,$tcdevices_defaults)
  create_resources('shorewall::tcrules',$tcrules,$tcrules_defaults)
  create_resources('shorewall::tcclasses',$tcclasses,$tcclasses_defaults)
  create_resources('shorewall::tunnel',$tunnels,$tunnels_defaults)
  create_resources('shorewall::rtrules',$rtrules,$rtrules_defaults)
}
