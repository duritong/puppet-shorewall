#
# modules/shorewall/manifests/init.pp - manage firewalling with shorewall 3.x
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# adapted by immerda project group - admin+puppet(at)immerda.ch
# adapted by Puzzle ITC - haerry+puppet(at)puzzle.ch
# Copyright (c) 2009 Riseup Networks - micah(shift+2)riseup.net
# See LICENSE for the full license granted to you.
# 
# Based on the work of ADNET Ghislain <gadnet@aqueos.com> from AQUEOS
# at https://reductivelabs.com/trac/puppet/wiki/AqueosShorewall
#
#
# If you need to install a specific version of shorewall other than
# the default one that would be installed by 'ensure => present', then
# you can set the following variable and that specific version will be
# installed instead:
#
# $shorewall_ensure_version = "4.0.15-1"
#
# Debian specific settings:
#
# To set any of the following, simply set them as variables in y our manifests
# before the class is included, for example:
#
# $shorewall_startboot = 1
#
# shorewall_startboot:   specify if shorewall should be enabled at boot
#                        valid options are: 1 (start at boot), 0 (do not start),
#                        Default: 1 -> start at boot
# 
# Changes:
#  * added Debian support to specify if shorewall should be enabled on boot or not
#  * added support for specifying shorewall package version
#  * updated indentation and formatting to standardize on puppet emacs/vim modes
#  * added support for traffic shapping: http://www.shorewall.net/traffic_shaping.htm
#  * added extension_script define: http://shorewall.net/shorewall_extension_scripts.htm
#  * FHS Layout: put configuration in /var/lib/puppet/modules/shorewall and
#    adjust CONFIG_PATH
#  * remove shorewall- prefix from defines in the shorewall namespace
#  * refactor the whole define structure
#  * manage all shorewall files
#  * add 000-header and 999-footer files for all managed_files
#  * added rule_section define and a few more parameters for rules
#  * add managing for masq, proxyarp, blacklist, nat, rfc1918

module_dir { "shorewall": }

class shorewall { 

  case $operatingsystem {
    gentoo: { include shorewall::gentoo }
    debian: { include shorewall::debian }
    default: { include shorewall::base }
  }

  file {
    "/var/lib/puppet/modules/shorewall":
      ensure => directory,
      force => true,
      mode => 0755, owner => root, group => 0;
  }

  # private
  define managed_file () {
    $dir = "/var/lib/puppet/modules/shorewall/${name}.d"
    concatenated_file { "/var/lib/puppet/modules/shorewall/$name":
      dir => $dir,
      mode => 0600,
    }
    file {
      "${dir}/000-header":
	source => "puppet://$server/modules/shorewall/boilerplate/${name}.header",
	mode => 0600, owner => root, group => 0,
	notify => Exec["concat_${dir}"];
      "${dir}/999-footer":
	source => "puppet://$server/modules/shorewall/boilerplate/${name}.footer",
	mode => 0600, owner => root, group => 0,
	notify => Exec["concat_${dir}"];
    }
  }
  
  # private
  define entry ($line) {
    $target = "/var/lib/puppet/modules/shorewall/${name}"
    $dir = dirname($target)
    file { $target:
      content => "${line}\n",
      mode => 0600, owner => root, group => 0,
      notify => Exec["concat_${dir}"],
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Zones
  managed_file{ zones: }
  define zone($type, $options = '-', $in = '-', $out = '-', $parent = '-', $order = 100) {
    $real_name = $parent ? { '-' => $name, default => "${name}:${parent}" }
    entry { "zones.d/${order}-${title}":
      line => "${real_name} ${type} ${options} ${in} ${out}"
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Interfaces
  managed_file{ interfaces: }
  define interface(
    $zone,
    $broadcast = 'detect',
    $options = 'tcpflags,blacklist,routefilter,nosmurfs,logmartians',
    $rfc1918 = false,
    $dhcp = false,
    $order = 100
  )
  {
    if $rfc1918 {
      if $dhcp {
	$options_real = "${options},dhcp"
	} else {
	$options_real = $options
	}
	} else {
	if $dhcp {
	  $options_real = "${options},norfc1918,dhcp"
	  } else {
	  $options_real = "${options},norfc1918"
	  }
	}
        
	entry { "interfaces.d/${order}-${title}":
	  line => "${zone} ${name} ${broadcast} ${options_real}",
	}
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Hosts
  managed_file { hosts: }
  define host($zone, $options = 'tcpflags,blacklist,norfc1918',$order='100') {
    entry { "hosts.d/${order}-${title}":
      line => "${zone} ${name} ${options}"
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Policy
  managed_file { policy: }
  define policy($sourcezone, $destinationzone, $policy, $shloglevel = '-', $limitburst = '-', $order) {
    entry { "policy.d/${order}-${title}":
      line => "# ${name}\n${sourcezone} ${destinationzone} ${policy} ${shloglevel} ${limitburst}",
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Rules
  managed_file { rules: }
  define rule_section($order) {
    entry { "rules.d/${order}-${title}":
      line => "SECTION ${name}",
    }
  }
  # mark is new in 3.4.4
  define rule($action, $source, $destination, $proto = '-',
  $destinationport = '-', $sourceport = '-', $originaldest = '-',
  $ratelimit = '-', $user = '-', $mark = '', $order)
  {
    entry { "rules.d/${order}-${title}":
      line => "# ${name}\n${action} ${source} ${destination} ${proto} ${destinationport} ${sourceport} ${originaldest} ${ratelimit} ${user} ${mark}",
    }
  }

  # See http://www.shorewall.net/3.0/Documentation.htm#Masq
  managed_file{ masq: }
  # mark is new in 3.4.4
  # source (= subnet) = Set of hosts that you wish to masquerade.
  # address = If  you  specify  an  address here, SNAT will be used and this will be the source address.
  define masq($interface, $source, $address = '-', $proto = '-', $port = '-', $ipsec = '-', $mark = '', $order='100' ) {
    entry { "masq.d/${order}-${title}":
      line => "# ${name}\n${interface} ${source} ${address} ${proto} ${port} ${ipsec} ${mark}"
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#ProxyArp
  managed_file { proxyarp: }
  define proxyarp($interface, $external, $haveroute = yes, $persistent = no, $order='100') {
    entry { "proxyarp.d/${order}-${title}":
      line => "# ${name}\n${name} ${interface} ${external} ${haveroute} ${persistent}"
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#NAT
  managed_file { nat: }
  define nat($interface, $internal, $all = 'no', $local = 'yes',$order='100') {
    entry { "nat.d/${order}-${title}":
      line => "${name} ${interface} ${internal} ${all} ${local}"
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Blacklist
  managed_file { blacklist: }
  define blacklist($proto = '-', $port = '-', $order='100') {
    entry { "blacklist.d/${order}-${title}":
      line => "${name} ${proto} ${port}",
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#rfc1918
  managed_file { rfc1918: }
  define rfc1918($action = 'logdrop', $order='100') {
    entry { "rfc1918.d/${order}-${title}":
      line => "${name} ${action}"
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Routestopped
  managed_file { routestopped: }
  define routestopped($interface = '', $host = '-', $options = '', $order='100') {
    $real_interface = $interface ? {
      '' => $name,
      default => $interface,
    }
    entry { "routestopped.d/${order}-${title}":
      line => "${real_interface} ${host} ${options}",
    }
  }
  
  # See http://www.shorewall.net/3.0/Documentation.htm#Variables 
  managed_file { params: }
  define params($value, $order='100'){
    entry { "params.d/${order}-${title}":
      line => "${name}=${value}",
    }
  }
  
  # See http://www.shorewall.net/3.0/traffic_shaping.htm
  managed_file { tcdevices: }
  define tcdevices($in_bandwidth, $out_bandwidth, $options = '', $redirected_interfaces = '', $order='100'){
    entry { "tcdevices.d/${order}-${title}":
      line => "${name} ${in_bandwidth} ${out_bandwidth} ${options} ${redirected_interfaces}",
    }
  }
  
  # See http://www.shorewall.net/3.0/traffic_shaping.htm
  managed_file { tcrules: }
  define tcrules($source, $destination, $protocol = 'all', $ports, $client_ports = '', $order='1'){
    entry { "tcrules.d/${order}-${title}":
      line => "# ${name}\n${order} ${source} ${destination} ${protocol} ${ports} ${client_ports}",
    }
  }
  
  # See http://www.shorewall.net/3.0/traffic_shaping.htm
  managed_file { tcclasses: }
  define tcclasses($interface, $rate, $ceil, $priority, $options = '' , $order='1'){
    entry { "tcclasses.d/${order}-${title}":
      line => "# ${name}\n${interface} ${order} ${rate} ${ceil} ${priority} ${options}",
    }
  }
  
  # See http://shorewall.net/shorewall_extension_scripts.htm
  define extension_script($script = '') {
    case $name {
      'init', 'initdone', 'start', 'started', 'stop', 'stopped', 'clear', 'refresh', 'continue', 'maclog': {
        managed_file { "${name}": }
        entry { "${name}.d/500-${hostname}":
          line => "${script}\n";
        }
      }
      '', default: {
        err("${name}: unknown shorewall extension script")
      }
    }
  }
}

class shorewall::base {

  if $shorewall_ensure_version == '' { $shorewall_ensure_version = 'present' }
  package { 'shorewall':
    ensure => $shorewall_ensure_version,
  }
  
  # This file has to be managed in place, so shorewall can find it
  file { "/etc/shorewall/shorewall.conf":
    # use OS specific defaults, but use Default if no other is found
    source => [
               "puppet://$fileserver/shorewall/${fqdn}/shorewall.conf.$operatingsystem",
               "puppet://$fileserver/shorewall/${fqdn}/shorewall.conf",
               "puppet://$fileserver/shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
               "puppet://$fileserver/shorewall/shorewall.conf.$operatingsystem",
               "puppet://$fileserver/shorewall/shorewall.conf",
               "puppet://$server/modules/shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
               "puppet://$server/modules/shorewall/shorewall.conf.$operatingsystem",
               "puppet://$server/modules/shorewall/shorewall.conf.Default"
               ],
    mode => 0644, owner => root, group => 0,
    require => Package[shorewall],
    notify => Service[shorewall],
  }

  service{ shorewall: 
    ensure  => running, 
    enable  => true, 
    hasstatus => true,
    hasrestart => true,
    subscribe => [ 
                   File["/var/lib/puppet/modules/shorewall/zones"], 
                   File["/var/lib/puppet/modules/shorewall/interfaces"], 
                   File["/var/lib/puppet/modules/shorewall/hosts"], 
                   File["/var/lib/puppet/modules/shorewall/policy"], 
                   File["/var/lib/puppet/modules/shorewall/rules"], 
                   File["/var/lib/puppet/modules/shorewall/masq"], 
                   File["/var/lib/puppet/modules/shorewall/proxyarp"], 
                   File["/var/lib/puppet/modules/shorewall/nat"], 
                   File["/var/lib/puppet/modules/shorewall/blacklist"], 
                   File["/var/lib/puppet/modules/shorewall/rfc1918"], 
                   File["/var/lib/puppet/modules/shorewall/routestopped"], 
                   File["/var/lib/puppet/modules/shorewall/params"],
                   File["/var/lib/puppet/modules/shorewall/tcdevices"], 
                   File["/var/lib/puppet/modules/shorewall/tcrules"], 
                   File["/var/lib/puppet/modules/shorewall/tcclasses"],
                   ],
    require => Package[shorewall],
  }
}

class shorewall::gentoo inherits shorewall::base {
  Package[shorewall]{
    category => 'net-firewall',
  }
}

class shorewall::debian inherits shorewall::base {

  # prepare variables to use in templates
  case $shorewall_startboot {
    '': { $shorewall_startboot = '1' }
  }
  
  file { '/etc/default/shorewall':
    content => template("shorewall/debian/default"),
    require => Package['shorewall'],
    notify => Service['shorewall'],
    owner => root, group => 0, mode => 0644;
  }
  Service['shorewall'] {
    status => '/sbin/shorewall status'
  }
}
