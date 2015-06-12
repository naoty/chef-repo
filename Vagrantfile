Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-6.5"

  config.vm.provision "chef_solo" do |chef|
    chef.data_bags_path = "data_bags"
    chef.run_list = %w(
      yum
      git
      ruby
      redis
      mysql
      imagemagick
    )
    chef.json = {
      ruby: {
        version: "2.0.0-p353"
      },
      mysql: {
        repository: "mysql-community-release-el6-5.noarch.rpm",
        socket: "/tmp/mysql.sock"
      },
      redis: {
        version: "2.8.13"
      }
    }
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # `vagrant up`時はコメントアウト
  config.vbguest.auto_update = true
end
