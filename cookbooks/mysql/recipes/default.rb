remote_file "/tmp/#{node['mysql']['repository']}" do
  source "http://dev.mysql.com/get/#{node['mysql']['repository']}"
end

rpm_package "/tmp/#{node['mysql']['repository']}"

%w(mysql-community-server mysql-community-devel).each do |package_name|
  package package_name
end

service "mysqld" do
  action [:enable, :start]
  supports restart: true, reload: true
end

template "/etc/my.cnf" do
  mode 0644
  owner "root"
  group "root"
  notifies :restart, "service[mysqld]"
end
