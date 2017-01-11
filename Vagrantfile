# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 1.6.0"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read YAML file with box details
servers = YAML.load_file('servers.yaml')

# Recreate hosts file based on servers.yaml
system('./update_hostfile.py')

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "mst" do |mst|
    mst.vm.box = "centos/7"
    mst.vm.network "forwarded_port", guest: 8080, host: 8080
    mst.vm.network "private_network", ip: "10.0.0.101"
    mst.vm.synced_folder "saltstack/salt/", "/srv/salt", type: "sshfs"
    mst.vm.synced_folder "saltstack/pillar/", "/srv/pillar", type: "sshfs"
    mst.vm.provision "shell" do |s|
      s.inline = "hostnamectl set-hostname $1"
      s.args = "mst"
    end
	mst.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = false
      salt.minion_config = "saltstack/etc/minion"
      salt.verbose = true
      salt.colorize = true
    end
    mst.vm.provision "shell", inline: "salt-call state.highstate"
  end
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      srv.vm.synced_folder '.', '/vagrant', disabled: true
      srv.vm.provision "shell" do |s|
        s.inline = "hostnamectl set-hostname $1"
        s.args = servers["name"]
      end
	  srv.vm.provision :salt do |salt|
        salt.install_type = "stable"
        salt.minion_config = "saltstack/etc/minion"
        salt.verbose = true
        salt.colorize = true
      end
      srv.vm.provision "shell", inline: "salt-call state.highstate"
    end
  end
end
