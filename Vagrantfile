# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
# Vagrant.configure("2") do |config|
#
#   if ENV['FIRST_RUN'] == 'true'
#     config.vbguest.auto_update = false
#     config.vm.synced_folder ".", "/vagrant", disabled: true
#   else
#     config.vm.synced_folder ".", "/vagrant", create: true, type: "virtualbox"
#     config.vm.synced_folder "./www", "/var/www", create: true, type: "virtualbox", owner: "www-data", group: "www-data"
#   end
# end
#
Vagrant.configure(2) do |config|

  config.vm.box = "debian/buster64"
  #config.vm.network "private_network", type: "dhcp"

#   if ENV['FIRST_RUN'] == 'true'
#     config.vbguest.auto_update = false
#     config.vm.synced_folder ".", "/vagrant", disabled: true
#   else
    config.vbguest.auto_update = true
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/vagrant_shared"
  #end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
      # Customize the amount of memory on the VM:
      vb.memory = "4096"
      vb.cpus    = 4
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
  config.vm.provision "shell", privileged: true, path: "provision.sh"


end
