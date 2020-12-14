# http://www.shorewall.net/manpages/shorewall-rules.html
# http://www.shorewall.net/manpages6/shorewall6-rules.html
define shorewall::rule(
  $action,
  $source,
  $destination,
  $proto           = '-',
  $destinationport = '-',
  $sourceport      = '-',
  $originaldest    = '-',
  $ratelimit       = '-',
  $user            = '-',
  $mark            = '-',
  $connlimit       = '-',
  $time            = '-',
  $headers         = '-',
  $switch          = '-',
  $helper          = '-',
  $order           = '500',
  $shorewall       = true,
  $shorewall6      = true,
  $ensure          = 'present',
){
  if versioncmp($facts['shorewall_version'],'4.5.7') >= 0 {
    $line = " ${connlimit} ${time} ${headers} ${switch} ${helper}"
  } elsif versioncmp($facts['shorewall_version'],'4.4.24') >= 0 {
    # el6
    $line = " ${connlimit} ${time} ${headers} ${switch}"
  } else {
    # el5
    $line = ''
  }
  $with_shorewall6 = $shorewall6 and $shorewall::with_shorewall6
  shorewall::entry{"rules-${order}-${name}":
    ensure     => $ensure,
    line       => "# ${name}\n${action} ${source} ${destination} ${proto} ${destinationport} ${sourceport} ${originaldest} ${ratelimit} ${user} ${mark}${line}",
    shorewall  => $shorewall,
    shorewall6 => $with_shorewall6,
  }
}
