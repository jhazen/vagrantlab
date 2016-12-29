# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "master" do |master|
    master.vm.box = "centos/7"
    master.vm.network "forwarded_port", guest: 8081, host: 8081
    master.vm.network "private_network", ip: "10.0.0.101"
    master.vm.synced_folder "saltstack/salt/", "/srv/salt"
    master.vm.synced_folder "saltstack/pillar/", "/srv/pillar"
    master.vm.provision "shell" do |s|
      s.inline = "echo $1 > /etc/hostname"
      s.args = "master"
    end
	master.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = false
      salt.minion_config = "saltstack/etc/minion"
      salt.verbose = true
      salt.colorize = true
    end
  end
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      srv.vm.synced_folder '.', '/vagrant', disabled: true
      srv.vm.provision "shell" do |s|
        s.inline = "echo $1 > /etc/hostname"
        s.args = servers["name"]
      end
	  srv.vm.provision :salt do |salt|
        salt.install_type = "stable"
        salt.minion_config = "saltstack/etc/minion"
        salt.verbose = true
        salt.colorize = true
      end
    end
  end
end
