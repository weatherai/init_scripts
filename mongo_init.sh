#!/bin/bash

# MongoDB installation

echo ##############################################
echo ##############################################
echo     Starting Database Initialization
echo ##############################################
echo ##############################################
sleep 3

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 68818C72E52529D4

sudo echo "deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

sudo apt-get update

sudo apt-get install -y mongodb-org

sudo systemctl enable mongod
sudo systemctl start mongod
sleep 5

# Initialize the DB with User and PW
echo -e "\n NOTE: IF YES, THE FILE WILL BE DELETED AFTER INITIALIZATION \n YOU WILL NOT HAVE ACCESS TO THE PASSWORD AFTER THIS STEP ANYMORE\n Initialize the database with the given credentials (mongo_init_script.js)?"
read -p "(y/n)" CONT
if [ "$CONT" = "y" ]; then
	echo "Okay, starting Initialization with given credentials"
	sleep 1
	  
	mongo < mongo_init_script.js


	sudo systemctl daemon-reload
	sudo service mongod restart

	# Enable authentication

	echo "
	[Unit]
	Description=MongoDB Database Server
	Documentation=https://docs.mongodb.org/manual
	After=network.target
	[Service]
	User=mongodb
	Group=mongodb
	EnvironmentFile=-/etc/default/mongod
	ExecStart=/usr/bin/mongod --auth --config /etc/mongod.conf
	PIDFile=/var/run/mongodb/mongod.pid
	# file size
	LimitFSIZE=infinity
	# cpu time
	LimitCPU=infinity
	# virtual memory size
	LimitAS=infinity
	# open files
	LimitNOFILE=64000
	# processes/threads
	LimitNPROC=64000
	# locked memory
	LimitMEMLOCK=infinity
	# total threads (user+kernel)
	TasksMax=infinity
	TasksAccounting=false
	# Recommended limits for for mongod as specified in
	# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings
	[Install]
	WantedBy=multi-user.target" | sudo tee /lib/systemd/system/mongod.service
	
	sudo systemctl daemon-reload
	sudo service mongod restart
	sudo rm mongo_init_script.js

else
	echo "Okay... Database initialized without password protection."
	sleep 1
fi


echo ##############################################
echo ##############################################
echo     Database successfully initialized
echo ##############################################
echo ##############################################