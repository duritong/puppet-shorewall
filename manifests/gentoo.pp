# gentoo specific things
class shorewall::gentoo inherits shorewall::base {
  Package['shorewall']{
    category => 'net-firewall',
  }
}
