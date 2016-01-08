#
# Cookbook Name:: .
# Recipe:: user
#
# Copyright (c) 2016 Joseph Caudle, All Rights Reserved.

group node['awesome_customers']['group']

user node['awesome_customers']['user'] do
  group node['awesome_customers']['group']
  system true
  shell '/bin/bash'
end
