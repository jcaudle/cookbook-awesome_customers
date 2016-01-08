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
  source 'customers.conf.erg'
  notifies :restart, 'httpd_service[customers]'
end

# Create the document root directory.
directory default['awesome_customers']['document_root'] do
  recursive true
end


# Write a default home page.
file "#{node['awesome_customers']['document_root']}/index.php" do
  content '<html>This is a placeholder</html>'
  mode '0644'
  owner default['awesome_customers']['user']
  group default['awesome_customers']['group']
end
