#
# Cookbook:: myweb
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

package 'git'
package 'tree'

package 'nginx' do
  action :install
end


service 'nginx' do
  action [ :enable, :start ]
end


directory '/var/www/html' do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
  notifies :create, 'cookbook_file[/var/www/html/index.html]'
end

cookbook_file "/var/www/html/index.html" do
  source "index.html"
  mode "0644"
  action :create
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  notifies :reload, "service[nginx]"
end
