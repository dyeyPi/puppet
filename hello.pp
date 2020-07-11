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
	mode => 'u+rwx',
   require => [User[$userId], Group[devs]],
}

file{ $scriptDir:
  ensure => directory,
	owner => $userId,
	mode => 'u+rwx',
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
	mode => 'u+rwx',
  require => [Exec["retrieve_memCheck1"], Exec["retrieve_memCheck2"]],
}

file{ $srcDir:
  ensure => 'directory',
  #* => $fileAttributes,
	owner => $userId,
	mode => 'u+rwx',
}

cron { 'run-puppet' :
  command => '/home/monitor/src/my_memory_check',
  user => 'monitor',
  hour => '*',
  minute => '*/15',
}

#class
