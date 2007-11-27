# modules/shorewall/manifests/init.pp - manage firewalling with shorewall 3.x
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
# 
# Based on the work of ADNET Ghislain <gadnet@aqueos.com> from AQUEOS
# at https://reductivelabs.com/trac/puppet/wiki/AqueosShorewall
#
# Changes:
#  * FHS Layout: put configuration in /var/lib/puppet/modules/shorewall and
#    adjust CONFIG_PATH
#  * remove shorewall- prefix from defines in the shorewall namespace
#  * refactor the whole define structure
#  * manage all shorewall files
#  * add 000-header and 999-footer files for all managed_files
#  * added rule_section define and a few more parameters for rules
#  * add managing for masq, proxyarp, blacklist, nat, rfc1918


modules_dir { "shorewall": }

class shorewall {

	package { 'shorewall':
                ensure => present,
                category => $operatingsystem ? {
                        gentoo => 'net-firewall',
                        default => '',
                },
        }


	service { shorewall: ensure  => running, enable  => true, }

	file {
        	"/var/lib/puppet/modules/shorewall":
        		ensure => directory,
        		force => true,
        		mode => 0755, owner => root, group => root;
        }
	
	# private
	define managed_file () {
		$dir = "/var/lib/puppet/modules/shorewall/${name}.d"

		file {
			"${dir}":
				ensure => directory,
	                        force => true,
       				mode => 0755, owner => root, group => root;
		}
				
		
		concatenated_file { "/var/lib/puppet/modules/shorewall/$name":
			dir => $dir,
			mode => 0600,
		}
		file {
			"${dir}/000-header":
				source => "puppet://$servername/shorewall/boilerplate/${name}.header",
				mode => 0600, owner => root, group => root,
				notify => Exec["concat_${dir}"];
			"${dir}/999-footer":
				source => "puppet://$servername/shorewall/boilerplate/${name}.footer",
				mode => 0600, owner => root, group => root,
				notify => Exec["concat_${dir}"];
		}
	}

	# private
	define entry ($line) {
		$target = "/var/lib/puppet/modules/shorewall/${name}"
		$dir = dirname($target)
		file { $target:
			content => "${line}\n",
			mode => 0600, owner => root, group => root,
			notify => Exec["concat_${dir}"],
		}
	}

	# This file has to be managed in place, so shorewall can find it
	file { "/etc/shorewall/shorewall.conf":
		# use OS specific defaults, but use gentoo if no other is found
		source => [
			"puppet://$servername/shorewall/shorewall.conf.$operatingsystem.$lsbdistcodename",
			"puppet://$servername/shorewall/shorewall.conf.$operatingsystem",
			"puppet://$servername/shorewall/shorewall.conf.Gentoo." ],
		mode => 0644, owner => root, group => root,
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Zones
	managed_file{ zones: }
	define zone($type, $options = '-', $in = '-', $out = '-', $parent = '-', $order = 100) {
		$real_name = $parent ? { '-' => $name, default => "${name}:${parent}" }
		entry { "zones.d/${order}-${name}":
			line => "${real_name} ${type} ${options} ${in} ${out}"
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Interfaces
	managed_file{ interfaces: }
	define interface($zone, $broadcast = 'detect', $options = 'tcpflags,blacklist,norfc1918,routefilter,nosmurfs,logmartians', $order='100') {
		entry { "interfaces.d/${order}-${name}":
			line => "${zone} ${name} ${broadcast} ${options}",
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Hosts
	managed_file { hosts: }
	define host($zone, $options = 'tcpflags,blacklist,norfc1918',$order='100') {
		entry { "hosts.d/${order}-${name}":
			line => "${zone} ${name} ${options}"
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Policy
	managed_file { policy: }
	define policy($sourcezone, $destinationzone, $policy, $shloglevel = '-', $limitburst = '-', $order) {
		entry { "policy.d/${order}-${name}":
			line => "# ${name}\n${sourcezone} ${destinationzone} ${policy} ${shloglevel} ${limitburst}",
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Rules
	managed_file { rules: }
	define rule_section($order) {
		entry { "rules.d/${order}-${name}":
			line => "SECTION ${name}",
		}
	}
	# mark is new in 3.4.4
	define rule($action, $source, $destination, $proto = '-',
		$destinationport = '-', $sourceport = '-', $originaldest = '-',
		$ratelimit = '-', $user = '-', $mark = '', $order)
	{
		entry { "rules.d/${order}-${name}":
			line => "# ${name}\n${action} ${source} ${destination} ${proto} ${destinationport} ${sourceport} ${originaldest} ${ratelimit} ${user} ${mark}",
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Masq
	managed_file{ masq: }
	# mark is new in 3.4.4
	# source (= subnet) = Set of hosts that you wish to masquerade.
	# address = If  you  specify  an  address here, SNAT will be used and this will be the source address.
	define masq($interface, $source, $address = '-', $proto = '-', $port = '-', $ipsec = '-', $mark = '', $order='100' ) {
		entry { "masq.d/${order}-${name}":
			line => "# ${name}\n${interface} ${source} ${address} ${proto} ${port} ${ipsec} ${mark}"
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#ProxyArp
	managed_file { proxyarp: }
	define proxyarp($interface, $external, $haveroute = yes, $persistent = no, $order='100') {
		entry { "proxyarp.d/${order}-${name}":
			line => "# ${name}\n${name} ${interface} ${external} ${haveroute} ${persistent}"
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#NAT
	managed_file { nat: }
	define nat($interface, $internal, $all = 'no', $local = 'yes',$order='100') {
		entry { "nat.d/${order}-${name}":
			line => "${name} ${interface} ${internal} ${all} ${local}"
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#Blacklist
	managed_file { blacklist: }
	define blacklist($proto = '-', $port = '-', $order='100') {
		entry { "blacklist.d/${order}-${name}":
			line => "${name} ${proto} ${port}",
		}
	}

	# See http://www.shorewall.net/3.0/Documentation.htm#rfc1918
	managed_file { rfc1918: }
	define rfc1918($action = 'logdrop', $order='100') {
		entry { "rfc1918.d/${order}-${name}":
			line => "${name} ${action}"
		}
	}
	
	# See http://www.shorewall.net/3.0/Documentation.htm#Routestopped
	managed_file { routestopped: }
	define routestopped($host = '-', $options = '', $order='100') {
		entry { "routestopped.d/${order}-${name}":
			line => "${name} ${host} ${options}",
		}
	}

}

