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

user { 'monitor':
    ensure  =>  'present',
    uid =>  '3001',
    shell =>  '/bin/bash',
    home =>  "/home/monitor",
}

file { '/home/monitor':
   ensure => 'directory',
   owner => 'monitor',
   group => 'devs',
   mode => 0750,
   require => [User['monitor'], Group[devs]]
}

file{'/home/monitor/scripts':
  mode => 'u+rwx',
  ensure => 'directory',
  owner => 'monitor',
}

exec{'retrieve_memCheck1':
  command => "/usr/bin/wget -q https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh",
  creates => "/home/monitor/scripts/memory_check.sh",
}

exec{'retrieve_memCheck2':
  command => "/usr/bin/wget -q https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh",
}

file{'/home/monitor/scripts/memory_check.sh':
  mode => 'u+rwx',
  ensure => file,
  recurse => true,
  owner => 'monitor',
  require => [Exec["retrieve_memCheck1"], Exec["retrieve_memCheck2"]],
}

file{'/home/monitor/src':
  mode => 'u+rwx',
  ensure => 'directory',
  owner => 'monitor',
}

cron { 'run-puppet' :
  command => '/home/monitor/src/my_memory_check',
  user => 'monitor',
  hour => '*',
  minute => '*/15',
}

