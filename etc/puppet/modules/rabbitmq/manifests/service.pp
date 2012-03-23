class rabbitmq::service {

	require rabbitmq::config

	service { "rabbitmq-server":
		ensure 		=> running,
		enable 		=> true,
		hasstatus 	=> true,
		hasrestart 	=> true,
	}

	exec { "rabbitmq-vhost":
		command 	=> "/usr/sbin/rabbitmqctl add_vhost <<rabbitmq_vhost>>",
		user 		=> "root",
		onlyif		=> "/usr/bin/test `/usr/sbin/rabbitmqctl list_vhosts | grep -c qmg_vhost` -eq 0",
		require		=> Service["rabbitmq-server"],
	}

	exec { "rabbitmq-user":
		command 	=> "/usr/sbin/rabbitmqctl add_user <<rabbitmq_user>> <<rabbitmq_password>>",
		user 		=> "root",
		onlyif		=> "/usr/bin/test `/usr/sbin/rabbitmqctl list_users | grep -c qmg` -eq 0",
		require		=> Exec["rabbitmq-vhost"],
	}

	exec { "rabbitmq-permissions":
		command 	=> "/usr/sbin/rabbitmqctl set_permissions -p <<rabbitmq_vhost>> <<rabbitmq_user>> \".*\" \".*\" \".*\"",
		user 		=> "root",
		onlyif		=> "/usr/bin/test `/usr/sbin/rabbitmqctl list_user_permissions <<rabbitmq_user>> | grep -c <<rabbitmq_vhost>>` -eq 0",
		require		=> Exec["rabbitmq-user"],
	}
}
