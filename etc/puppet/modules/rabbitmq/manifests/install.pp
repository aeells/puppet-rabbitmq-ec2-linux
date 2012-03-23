class rabbitmq::install {

	exec { "download-erlang":
		command 	=> "/usr/bin/wget http://binaries.erlang-solutions.com/R15B/Centos%206.0%20x86_64/esl-erlang-R15B-1.x86_64.rpm",                                                         
		cwd 		=> "/usr/local",
		creates 	=> "/usr/local/esl-erlang-R15B-1.x86_64.rpm",                                                              
		user 		=> "root",
	}

	exec { "download-rabbitmq":
		command 	=> "/usr/bin/wget http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.0/rabbitmq-server-2.8.0-1.noarch.rpm",                                                         
		cwd 		=> "/usr/local",
		creates 	=> "/usr/local/rabbitmq-server-2.8.0-1.noarch.rpm",                                                              
		user 		=> "root",
		require		=> Exec["download-erlang"],
	}

	# puppet doesnt support the --nodeps option with rpm package hence using exec

	exec { "install-erlang":
		command 	=> "/bin/rpm -ivh --nodeps esl-erlang-R15B-1.x86_64.rpm",                                                         
		cwd 		=> "/usr/local",
		onlyif		=> "/usr/bin/test `/usr/bin/which erl | grep -c erl` -eq 0",
		user 		=> "root",
		require		=> Exec["download-erlang"],
	}	

	exec { "install-rabbitmq":
		command 	=> "/bin/rpm -ivh --nodeps rabbitmq-server-2.8.0-1.noarch.rpm",                                                         
		cwd 		=> "/usr/local",
		onlyif		=> "/usr/bin/test `/usr/bin/which rabbitmq-server | grep -c rabbitmq-server` -eq 0",
		user 		=> "root",
		require		=> Exec["download-rabbitmq"],
	}	
}
