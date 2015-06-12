Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-6.5"

  config.vm.provision "chef_solo" do |chef|
    chef.data_bags_path = "data_bags"
    chef.run_list = %w(
      yum
      git
      ruby
      openjdk
      mysql
      redis
      solr
      imagemagick
    )
    chef.json = {
      mysql: {
        repository: "mysql-community-release-el6-5.noarch.rpm",
        socket: "/tmp/mysql.sock"
      },
      openjdk: {
        version: "1.7.0"
      },
      redis: {
        version: "2.8.13"
      },
      ruby: {
        version: "2.0.0-p353"
      },
      solr: {
        version: "4.7.1"
      }
    }
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # Comment out a below line when `vagrant up`
  config.vbguest.auto_update = true
end
