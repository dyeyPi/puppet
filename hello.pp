$userId=monitor
$userDir="/home/${userId}"
$scriptDir="${userDir}/scripts"
$srcDir="${userDir}/src"
$rawLink='https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh'
$rawFile='memory_check'
$rawDir="${scriptDir}/${rawFile}"

$dependencies = [
	'vim-minimal',
	'curl',
	'git',
]

$packageAttributes = {
	'required' => true,
  'packages'=> $dependencies,
}

$required=true
if $required {
	package{ $dependencies:
 		ensure => latest,
	}
} else {
  package { $dependencies :
		ensure => absent,
	}
}

user { $userId:
    ensure  =>  present,
    uid =>  '3001',
    #* => $userAttributes,
		shell => $userAttributes,
		home => $userDir,
}

group { 'devs':
   gid =>  3000,
}

file { $userDir:
   ensure => directory,
	 #* => $fileAttributes,
	owner => $userId,
	mode => '0755',
   require => [User[$userId], Group[devs]],
}

file{ $scriptDir:
  ensure => directory,
	owner => $userId,
	mode => '0755',
}

exec{'retrieve_memCheck1':
  command => "/usr/bin/wget -q ${rawLink}",
  creates => $rawDir,
}

exec{'retrieve_memCheck2':
  command => "/usr/bin/wget -q ${rawLink} -O ${rawDir}",
}

file{ $rawDir:
  ensure => file,
  recurse => true,
	owner => $userId,
	mode => '0755',
  require => [Exec["retrieve_memCheck1"], Exec["retrieve_memCheck2"]],
}

file{ $srcDir:
  ensure => 'directory',
  #* => $fileAttributes,
	owner => $userId,
	mode => '0755',
}

file { "${srcDir}/my_memory_check":
	ensure => 'link',
	mode => '0755',
	owner => $userId,
	target => "${scriptDir}/memory_check",
	force => yes,
}	


cron { 'puppet-apply':
	ensure => present,
	command => 'bash my_memory_check',
  user => $userId,
	hour => '*',
	minute => '10',
	require => File["${srcDir}/my_memory_check"],
}

