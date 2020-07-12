Puppet task repository

home_memCheck = { *key: value object like pair
	packages: dependencies = [vim, curl, git],
	user: [
	 { createParams: default = {
		name : monitor,
		uid : '3001',
		pass : this.name,
		home : /home/this.name,
		shell: '/bin/bash'
	 },filePermissions : access = {
		owner : defaultUser['name'],
		group : #define,
		mode : '0755'
	}, workingGroup: group = {
		name: #define,
		gid : '3000'
	} ],
}  
	
