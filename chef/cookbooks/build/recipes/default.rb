#
# Cookbook:: build
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

package 'git'
package 'golang' do
  action :install
  notifies :run, 'execute[install_gopacket]', :immediately
end
package 'golang-docs'
package 'python34'
package 'nodejs'
package 'java-1.8.0-openjdk'
package 'java-1.8.0-openjdk-devel'
package 'nasm'
package 'gcc-c++'

execute 'install_gopacket' do
  command 'go get github.com/google/gopacket'
  action :nothing
end
