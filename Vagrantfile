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
  config.vm.define "mst1" do |mst1|
    mst1.vm.box = "centos/7"
    mst1.vm.network "private_network", ip: "10.1.0.101"
    mst1.vm.synced_folder "saltstack/salt/", "/srv/salt", type: "sshfs"
    mst1.vm.synced_folder "saltstack/pillar/", "/srv/pillar", type: "sshfs"
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
  end
  servers.each do |servers|
    config.vm.define servers["name"] do |srv|
      srv.vm.box = servers["box"]
      srv.vm.network "private_network", ip: servers["ip"]
      srv.vm.synced_folder '.', '/vagrant', disabled: true
      if servers["nics"]
        servers["nics"].each do |nics|
          srv.vm.network "private_network", ip: nics["ip"], virtualbox__intnet: nics["net"]
        end
      end
      if servers["box"] == "veos"
				srv.vm.provision 'shell', inline: <<-SHELL
					FastCli -p 15 -c "configure
					username admin privilege 15 role network-admin secret admin
					management api http-commands
					no shutdown
					end
					copy running-config startup-config"
				SHELL
				srv.vm.provision "shell" do |s|
					s.inline = "FastCli -p 15 -c \"configure\nhostname $1\nend\ncopy run start\n\""
					s.args = servers["name"]
				end
      else
        srv.vm.provision "shell" do |s|
          s.inline = "hostnamectl set-hostname $1"
          s.args = servers["name"]
        end
        # Probably, all Debian systems will be affected, not just cumulus, TODO
        if servers["box"] == "CumulusCommunity/cumulus-vx"
          srv.vm.provision "shell" do |s|
            s.inline = "echo '10.1.0.101 mst1 salt' >> /etc/hosts"
          end
          srv.vm.provision "shell" do |s|
            s.inline = "echo $1 $2 >> /etc/hosts"
            s.args = servers["ip"], servers["name"]
          end
          srv.vm.provision "shell" do |s|
            s.inline = "wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add - > /dev/null 2>&1"
          end
          srv.vm.provision "shell" do |s|
            s.inline = "echo 'deb https://repo.saltstack.com/apt/debian/8/amd64/latest jessie main' > /etc/apt/sources.list.d/saltstack.list"
          end
          srv.vm.provision "shell" do |s|
            s.inline = "apt-get update"
          end
          srv.vm.provision "shell" do |s|
            s.inline = "apt-get -y install salt-minion"
          end
          srv.vm.provision "shell" do |s|
            s.inline = "systemctl start salt-minion"
          end
        else
          srv.vm.provision :salt do |salt|
            salt.install_type = "stable"
            salt.minion_config = "saltstack/etc/minion"
            salt.verbose = true
            salt.colorize = true
          end
        end
        srv.vm.provision "shell", inline: "salt-call state.highstate"
      end
    end
  end
end
