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

def pass
end

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  config.nfs.functional = false
  config.vm.define "mst1" do |mst1|
    mst1.vm.box = "centos/7"
    mst1.vm.network "private_network", ip: "192.168.200.11"
    mst1.vm.synced_folder "saltstack/salt/", "/srv/salt", type: "rsync"
    mst1.vm.synced_folder "saltstack/pillar/", "/srv/pillar", type: "rsync"
    mst1.vm.provision "shell" do |s|
      s.inline = "hostnamectl set-hostname $1"
      s.args = "mst1"
    end
	mst1.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/master"
      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = false
      salt.minion_config = "saltstack/etc/minion"
      salt.verbose = true
      salt.colorize = true
    end
    mst1.vm.provision "shell", inline: "salt-call state.highstate"
    mst1.vm.network "forwarded_port", guest: 8080, host: 8080
  end
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.hostname = servers["name"]
      if servers["role"] == "juniper"
        srv.vm.network "private_network", ip: servers["ip"], auto_config: false, nic_type: '82540EM'
      else
        srv.vm.network "private_network", ip: servers["ip"]
      end
      srv.vm.synced_folder '.', '/vagrant', type: "sshfs", disabled: true
      if servers["forwarded_port"]
        servers["forwarded_port"].each do |forwarded_port|
          srv.vm.network "forwarded_port", guest: forwarded_port["guest"], host: forwarded_port["host"]
        end
      end
      if servers["wan"]
        servers["wan"].each do |wan|
          if servers["role"] == "juniper"
            srv.vm.network "private_network", ip: wan["ip"], auto_config: false, nic_type: '82540EM'
          else
            srv.vm.network "private_network", ip: wan["ip"]
          end
        end
      end
      if servers["nics"]
        servers["nics"].each do |nics|
          if servers["role"] == "juniper"
            srv.vm.network "private_network", ip: nics["ip"], virtualbox__intnet: nics["net"], auto_config: false, nic_type: '82540EM'
          else
            srv.vm.network "private_network", ip: nics["ip"], virtualbox__intnet: nics["net"]
          end
        end
      end
      if servers["provision"] == "salt"
        srv.vm.provision "shell" do |s|
          s.inline = "hostnamectl set-hostname $1"
          s.args = servers["name"]
        end
        srv.vm.provision :salt do |salt|
          salt.install_type = "stable"
          salt.minion_config = "saltstack/etc/minion"
          salt.minion_id = servers["name"]
          salt.verbose = true
          salt.colorize = true
          if servers["role"]
            srv.vm.provision "shell" do |s|
              s.inline = "salt-call grains.append roles $1"
              s.args = servers["role"]
            end
          end
          srv.vm.provision "shell", inline: "salt-call state.highstate"
        end
      elsif servers["provision"] == "chef"
        srv.vm.provision "shell" do |s|
          s.inline = "hostnamectl set-hostname $1"
          s.args = servers["name"]
        end
        srv.vm.provision "chef_solo" do |chef|
          chef.synced_folder_type = "sshfs"
          chef.cookbooks_path = "chef/cookbooks"
          chef.roles_path = "chef/roles"
          if servers["role"]
            chef.add_role(servers["role"])
          end
        end
      end
    end
  end
end
