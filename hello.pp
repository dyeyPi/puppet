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

