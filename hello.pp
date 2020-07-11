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

$userAttributes = {
	'shell' => '\bin\bash',
	'home' => $userDir,
}

$fileAttributes = {
	'owner' => $userId,
	'group' => 'devs',
	'mode' => 'u+rwx'
}

$packageAttributes = {
	'required' => true,
  'packages'=> $dependencies,
}

if $packageAttributes['required'] {
	package{ $dependencies:
 		ensure => installed,
	}
} else {
  package { $dependencies :
		ensure => absent,
	}
}

user { $userId:
    ensure  =>  present,
    uid =>  '3001',
    * => $userAttributes,
}

group { 'devs':
   gid =>  3000,
}

file { $userDir:
   ensure => directory,
	 * => $fileAttributes,
   require => [User[$userId], Group[devs]],
}

file{ $scriptDir:
  ensure => directory,
  * => $fileAttributes,
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
  require => [Exec["retrieve_memCheck1"], Exec["retrieve_memCheck2"]],
	* => $fileAttributes,
}

file{ $srcDir:
  ensure => 'directory',
  * => $fileAttributes,
}

cron { 'run-puppet' :
  command => '/home/monitor/src/my_memory_check',
  user => 'monitor',
  hour => '*',
  minute => '*/15',
}

#class
