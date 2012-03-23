class rabbitmq::config {

	require rabbitmq::install

	file { "/etc/rabbitmq":
		ensure 		=> "directory",
		owner 		=> "root",
		group 		=> "root",
		mode 		=> 755,
		replace 	=> false,
	}

	file { "/etc/rabbitmq/rabbitmq.config":
		owner 	   	=> "root",
		group 	   	=> "root",
		mode	   	=> 644,
		content    	=> template("rabbitmq/rabbitmq.config.erb"),
		require    	=> File["/etc/rabbitmq"],
		notify	   	=> Service["rabbitmq-server"],
	}
	
	file { "/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.0/sbin/rabbitmq-env":
		owner 	   	=> "root",
		group 	   	=> "root",
		mode 	   	=> 755,
		source 	   	=> "puppet://$puppetserver/modules/rabbitmq/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.0/sbin/rabbitmq-env",
		require    	=> File["/etc/rabbitmq/rabbitmq.config"],
		notify	   	=> Service["rabbitmq-server"],
	}
	
	exec { "rabbitmq-plugins":
		command 	=> "/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.0/sbin/rabbitmq-plugins enable mochiweb webmachine amqp_client rabbitmq_mochiweb rabbitmq_management_agent rabbitmq_management rabbitmq_shovel",
		user 		=> "root",
		onlyif		=> "/usr/bin/test `/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.0/sbin/rabbitmq-plugins list | grep -c mochiweb` -eq 0",
		require     => File["/usr/lib/rabbitmq/lib/rabbitmq_server-2.8.0/sbin/rabbitmq-env"],
		notify	   	=> Service["rabbitmq-server"],
	}
}
