apt_update = execute "update apt" do
  user "root"
  command "apt-get update"
  action :nothing
end
apt_update.run_action(:run)

# we don't actually need all these. I just like to have them.
%w{vim curl man-db git-core}.each do | pkg |
  install_package = package pkg do
    action :nothing
  end
  install_package.run_action(:install)
end

# no webserver! node will listen on port 80. As root! Hence, development.
include_recipe "nodejs"
include_recipe "nodejs::npm"

# install our required npm modules
node[:node_modules].each do | node_module |
  bash "npm install #{node_module}" do
    user "root"
    code "npm install #{node_module} -g"
    not_if "npm ls -g | grep #{node_module}"
  end
end

bash "run the node app with supervisor" do
  not_if "ps aux|grep -vq grep|grep -q supervisor"
  user "root"
  cwd "/var/www/#{node[:app][:name]}"
  code "supervisor app.js &> /tmp/node.log &"
end
