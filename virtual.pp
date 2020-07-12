define accounts::virtual ($uid,$realname,$pass) {

  user { $title:
    ensure    =>  'present',
    uid       =>  $uid,
    gid       =>  $title,
    shell     =>  '/bin/bash',
    home      =>  "/home/${title}",
    comment   =>  $realname,
    password  =>  $pass,
    managehome =>  true,
    require    =>  Group[$title],
  }

  group { $title:
    gid =>  $uid,
  }

  file { "/home/${title}":
    ensure =>  directory,
    owner =>  $title,
    group =>  $title,
    mode =>  0750,
    require =>  [ User[$title], Group[$title] ],
  }
}

define accounts::dependencies ($package1, $package2, $package3) {
	package { $package1,
		ensure => $title,
	}
	
	package { $package2,
		ensure => $title,
	}

	package { $package3,
		ensure => $title,
	}
}

define accounts::scripts ($ownerid, $rawLink, $script1, $rwCode) {
	file { "/home/${ownerid}/${title}":
 		ensure => directory,
		owner => $ownerid,
		mode => $rwCode,
	}

	exec { 'retrieve_memCheck1':
  		command => "/usr/bin/wget -q ${rawLink}",
  		creates => "/home/${owner}/${title}/${script1}",
	}

	exec { 'retrieve_memCheck2':
  		command => "/usr/bin/wget -q ${rawLink} -O /home/${owner}/${title}/${script1}",
		creates => "/home/${owner}/${title}/${script1}",
	}

	file { "/home/${owner}/${title}/${script1}":
  		ensure => file,
  		recurse => true,
		owner => $ownerid,
		mode => $rwCode,
 		require => [Exec["retrieve_memCheck1"], Exec["retrieve_memCheck2"]],
	}
}

	define accounts::src_cron ($ownerid, $cron1, $rwCode) {
		file{ "/home/${ownerid}/${title}":
	  ensure => 'directory',
	  owner => $ownerid,
		mode => $rwCode,
	}

	file { $cron1:
		ensure => 'link',
		mode => $rwCode,
		owner => $ownerid,
		path => "/home/${ownerid}/${title}/${cron1}",
		force => yes,
		target => "/home/${ownerid}/scripts/memory_check",
}	

	cron { 'memCheck-apply':
		ensure => present,
		command => "/home/${ownerid}/${title}/${cron1} -c 90 -w 60 -e ako@email.com",
		user => $ownerid,
		hour => '*',
		minute => '10',
		require => File[$cron1],
	}

}
