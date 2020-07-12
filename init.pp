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
		rawLink => 'https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh',
		scriptDir => '/home/monitor/scripts',
		script1 => 'memory_check',
	}

	@accounts::srccron { 'src':
		srcDir => '/home/monitor/src',
		cron1 => 'my_memory_check'
	}
}



	$version = 'latest',
	$userId=monitor,
	$userDir="/home/${userId}",
	$scriptDir="${userDir}/scripts",
	$srcDir="${userDir}/src",
	$rawLink='https://raw.githubusercontent.com/dyeyPi/voyager/master/memory_check.sh',
	$rawFile='memory_check',
	$rawDir="${scriptDir}/${rawFile}",
