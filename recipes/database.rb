#
# Cookbook Name:: awesome_customers
# Recipe:: database
#
# Copyright (c) 2016 Joseph Caudle, All Rights Reserved.

# Configure the mysql2 Ruby gem.
mysql2_chef_gem 'default' do
  action :install
end

# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Load the secrets file and the encrypted data bag item that holds the root password.
password_secret = Chef::EncryptedDataBagItem.load_secret(node['awesome_customers']['passwords']['secret_path'])
root_password_data_bag_item = Chef::EncryptedDataBagItem.load('passwords', 'sql_server_root_password', password_secret)

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password root_password_data_bag_item['password']
  action [:create, :start]
end

mysql_database node['awesome_customers']['database']['dbname'] do
  connection(
    :host => node['awesome_customers']['database']['host'],
    :username => node['awesome_customers']['database']['username'],
    :password => root_password_data_bag_item['password']
  )
  action :create
end
