$userId=monitor
$userDir="/home/${userId}"
$scriptDir="${userDir}/scripts"
$srcDir="${userDir}/src"
$rawLink='https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh'
$rawFile='memory_check'
$rawDir="${scriptDir}/${rawFile}"

package{ 'vim-minimal':
  ensure => latest,
}

package{ 'curl':
  ensure => latest,
}

package{ 'git':
  ensure => latest,
}

group { 'devs':
   gid =>  3000,
}

user { $userId:
    ensure  =>  present,
    uid =>  '3001',
    shell =>  '/bin/bash',
    home =>  $userDir,
}

file { $userDir:
   ensure => directory,
   owner => $userId,
   group => 'devs',
   mode => 0750,
   require => [User[$userId], Group[devs]]
}

file{ $scriptDir:
  mode => 'u+rwx',
  ensure => directory,
  owner => $userId,
}

exec{'retrieve_memCheck1':
  command => "/usr/bin/wget -q ${rawLink}",
  creates => $rawDir,
}

exec{'retrieve_memCheck2':
  command => "/usr/bin/wget -q ${rawLink} -O ${rawDir}",
}

file{ $rawDir:
  mode => 'u+rwx',
  ensure => file,
  recurse => true,
  owner => $userId,
  require => [Exec["retrieve_memCheck1"], Exec["retrieve_memCheck2"]],
}

file{ $srcDir:
  mode => 'u+rwx',
  ensure => 'directory',
  owner => $userId,
}

cron { 'run-puppet' :
  command => '/home/monitor/src/my_memory_check',
  user => 'monitor',
  hour => '*',
  minute => '*/15',
}

#class
