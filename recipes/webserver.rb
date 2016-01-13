#
# Cookbook Name:: .
# Recipe:: webserver
#
# Copyright (c) 2016 Joseph Caudle, All Rights Reserved.

# Install Apache and start the service.
httpd_service 'customers' do
  mpm 'prefork'
  action [:create, :start]
end

# Add the site configuration.
httpd_config 'customers' do
  instance 'customers'
  source 'customers.conf.erb'
  notifies :restart, 'httpd_service[customers]'
end

# Create the document root directory.
directory node['awesome_customers']['document_root'] do
  recursive true
end


# Write a default home page.
file "#{node['awesome_customers']['document_root']}/index.php" do
  content '<html>This is a placeholder</html>'
  mode '0644'
  owner node['awesome_customers']['user']
  group node['awesome_customers']['group']
end

# Open port 80 to incoming traffic.
firewall_rule 'http' do
  port 80
  protocol :tcp
  action :allow
end

# Install the mod_php5 Apache module.
httpd_module 'php5' do
  instance 'customers'
end

# Install php5-mysql.
package 'php5-mysql' do
  action :install
  notifies :restart, 'httpd_service[customers]'
end
