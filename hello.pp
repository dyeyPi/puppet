file { '/root/Desktop/hello.txt':
  ensure  => file,
  content => "hello, Puppet\n",
}

