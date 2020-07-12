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
		owner : ..defaultUser['name'],  
		group : #define,  
		mode : '0755'  
	}, workingGroup: group = {  
		name: #define,  
		gid : '3000'  
	} ],  
	scripts:  
	[ memory_check: params = {  
		name: memory_check,  
		script: #provide link,  
		location: ..defaultUser['home']/scripts  
   	}, *future scripts  
        ],  
	src:   
	[ my_memory_check: params = {  
		name: my_memory_check,  
		link: ..scripts[mem_check['script']],  
		location: ..defaultUser['home']/src  
	}, *future cron src  
	],   
	do_task: function () {  
		install packages specified []  
		creater user with {properties}  
		create scripts with {properties}  
		create src with {properties} --for cron jobs to look at  
	}  
}    
	
The puppet class consists of state(properties) and behaviors(methods) that  
are enclosed inside the task's class.  

Limitations:  
	Default parameters are not based on a specific standard profile.  
	Structure defined for this documentation is based on ECMAscript  

