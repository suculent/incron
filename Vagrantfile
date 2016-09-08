# -*- mode: ruby -*-
# vi: set ft=ruby :

appname = 'jalousie'

Vagrant.configure("2") do |config|

  config.vm.box = "marcoaltieri/ubuntu-desktop-16.04-64bit"
  config.vm.box_check_update = false
  config.vm.network "forwarded_port", guest: 80, host: 30000
  config.vm.network "forwarded_port", guest: 443, host: 30443
  config.vm.network "private_network", ip: "192.168.44.11"  
  config.vm.provision 'shell', inline: 'echo "127.0.1.1 ubuntu-xenial" >> /etc/hosts'
  config.vm.synced_folder "./incron/", "/incron", nfs: false
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision "shell", inline: <<-SHELL

    # go to shared folder with installation
    cd /incron

    # env vars, TODO: parametrize username and password, or change in cfg.inc    
    APPNAME=#{appname}
    APPUSER=apprepo
    APPPASS=apprepo
    WEBUSER=www-data

    #
    # Install Apache 2.4 and Incron
    #

    sudo apt-get install -y apache2 php incron libapache2-mod-php sshpass  

    #
    # User
    #

    # add the application user with password and allow sudo
    sudo adduser $APPUSER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
    sudo echo $APPUSER:$APPPASS | sudo chpasswd
    sudo echo "$APPUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    # allow user to use incron
    sudo echo "$APPUSER" >> /etc/incron.allow

    #
    # SSH
    #

    # disable host checking for local-host
    echo "Host 127.0.0.*\nStrictHostKeyChecking no\nUserKnownHostsFile=/dev/null" >> sudo /etc/ssh/ssh_config

    #
    # File-system fixes, should be done by deploy.sh
    #

    sudo mkdir -p /var/www/html/$APPNAME
    sudo chmod -R 775 /var/www/html/ 
    sudo chown -R $APPUSER:$APPUSER /var/www/html
      
    sudo touch /var/spool/incron/$APPNAME
    sudo chown $APPUSER:$APPUSER /var/spool/incron/$APPNAME
    sudo chmod 755 /var/spool/incron/$APPNAME

    # must be writable by php
    sudo mkdir -p /var/www/incron/$APPNAME/exec
    sudo chmod -R 777 /var/www/incron/$APPNAME/exec
    sudo mkdir -p /var/www/incron/$APPNAME/in
    sudo chmod -R 777 /var/www/incron/$APPNAME
    sudo chown -R $WEBUSER:$WEBUSER /var/www/incron/$APPNAME/in/

    sudo touch /var/spool/incron/apprepo
    sudo chmod -R 777 /var/spool/incron/apprepo

    sudo chmod -R 777 /var/www/incron/$APPNAME/in/
    #sudo chmod -R o+w /var/www/incron/$APPNAME/in/

    #
    # Call underlying deploy
    #
    
    sudo bash deploy.sh

  SHELL

end

system("open http://localhost:30000/#{appname}/")
