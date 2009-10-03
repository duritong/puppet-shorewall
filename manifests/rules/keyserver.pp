class shorewall::rules::keyserver {
	shorewall::rule {
		'net-me-tcp_keyserver':
      source      => 'net',
  		destination     => '$FW',
	  	proto           => 'tcp',
		  destinationport => '11371',
   		order           => 240,
	    action          => 'ACCEPT';
	}
}
