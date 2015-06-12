remote_file "/tmp/redis-#{node['redis']['version']}.tar.gz" do
  source "http://download.redis.io/releases/redis-#{node['redis']['version']}.tar.gz"
  not_if { ::File.exist?("/tmp/#{node['redis']['version']}.tar.gz") }
end

bash "build and install redis" do
  cwd "/tmp"
  code <<-EOF
    tar -zxf redis-#{node['redis']['version']}.tar.gz
    (cd redis-#{node['redis']['version']} && make && make install)
    cp /tmp/redis-#{node['redis']['version']}/redis.conf /etc/redis.conf
    sed -i 's/daemonize no/daemonize yes/g' /etc/redis.conf
  EOF
  not_if { ::File.exist?("/tmp/redis-#{node['redis']['version']}") }
end

execute "update redis.conf logfile" do
  command <<-EOF
    sed -i 's/logfile ""/logfile \\/var\\/log\\/redis.log/g' /etc/redis.conf
  EOF
  only_if { ::File.exist?("/etc/redis.conf") }
end

cookbook_file "/etc/init.d/redis" do
  source "redis"
  mode 0755
end

execute "set over commit" do
  command "echo 'vm.overcommit_memory = 1' > /etc/sysctl.conf"
  not_if "cat /etc/sysctl.conf | grep vm.overcommit_memory"
end

execute "add chkconfig" do
  command "chkconfig --add /etc/init.d/redis"
  not_if "chkconfig --list | grep redis"
end

service "redis" do
  action [:enable, :restart]
end
