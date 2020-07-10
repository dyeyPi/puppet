package{ 'vim-minimal':
  ensure => present,
}

package{ 'curl':
  ensure => present,
}

package{ 'git':
  ensure => present,
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
   ensure => directory,
   owner => 'monitor',
   group => 'devs',
   mode => 0750,
   require => [User['monitor'], Group[devs]]
}

file{'/home/monitor/scripts':
  mode => 0750,
  ensure => directory,
  owner => 'monitor',
}

exec{'retrieve_memCheck':
  command => "/usr/bin/wget -q https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh -O /home/monitor/scripts/memory_check.sh",
  creates => "/home/monitor/scripts/memory_check.sh",
}

file{'/home/monitor/scripts/memory_check.sh':
  mode => 0750,
  require => Exec["retrieve_memCheck"],
  ensure => present,
  owner => 'monitor',
}
