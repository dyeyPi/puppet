class accounts {

  @accounts::virtual { 'monitor':
    uid      =>  1001,
    realname =>  'Patrick Andrey',
    pass     =>  'default',		
  }

	@accounts::dependencies { 'latest':
		package1 =>  'vim-minimal',
		package2 =>  'curl',
		package3 =>  'git,
	}

	@accounts::scripts { 'scripts':
		ownerid => 'monitor',
		rawLink => 'https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh',
		script1 => 'memory_check',
		rwCode => '0750',
	}

	@accounts::src_cron { 'src':
		ownerid => 'monitor',
		cron1 => 'my_memory_check',
		rwCode = '0750',
	}

}
