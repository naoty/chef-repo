# user
vagrant = data_bag_item("users", "vagrant")
home = vagrant["home"]
username = vagrant["username"]
group = vagrant["group"]
path = "#{home}/.rbenv/shims:/usr/bin:/usr/sbin:/bin:/sbin"

# requirements
# cf) https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment
%w(
  gcc gcc-c++ openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel
  gdbm-devel ncurses-devel libxml2-devel libxslt-devel
).each do |package_name|
  package package_name
end

# rbenv
git "#{home}/.rbenv" do
  repository "https://github.com/sstephenson/rbenv"
  user username
  group group
end

# .bash_profile
template "#{home}/.bash_profile" do
  mode 0644
  owner username
  group group
  not_if "grep rbenv #{home}/.bash_profile"
end

# ruby-build
directory "#{home}/.rbenv/plugins" do
  mode 0755
  owner username
  group group
end

git "#{home}/.rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build"
  user username
  group group
end

# ruby
ruby_version = node["ruby"]["version"]
execute "rbenv install #{ruby_version}" do
  command "#{home}/.rbenv/bin/rbenv install #{ruby_version}"
  user username
  group group
  environment "HOME" => home
  not_if { File.exist?("#{home}/.rbenv/versions/#{ruby_version}") }
end

execute "rbenv global #{ruby_version}" do
  command "#{home}/.rbenv/bin/rbenv global #{ruby_version}"
  user username
  group group
  environment "HOME" => home
end

execute "gem install bundler" do
  cwd "/vagrant"
  user username
  group group
  environment "PATH" => path
end
