# user
vagrant = data_bag_item("users", "vagrant")
username = vagrant[:username]
group = vagrant[:group]

remote_file "/tmp/solr-#{node[:solr][:version]}.tgz" do
  source "https://archive.apache.org/dist/lucene/solr/#{node[:solr][:version]}/solr-#{node[:solr][:version]}.tgz"
  action :create_if_missing
end

execute "tar xzvf /tmp/solr-#{node[:solr][:version]}.tgz -C /opt" do
  creates "/opt/solr-#{node[:solr][:version]}"
  user username
  group group
end
