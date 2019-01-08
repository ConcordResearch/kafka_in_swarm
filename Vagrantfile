# -*- mode: ruby -*-
# vi: set ft=ruby :

#BOX_IMAGE = "bento/ubuntu-16.04"
#BOX_VERSION = "201806.08.0"
BOX_IMAGE = "bento/ubuntu-18.04"
BOX_VERSION = "201806.08.0"
NODE_COUNT = 5
Vagrant.configure("2") do |config|
  config.vm.define "master" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.box_version = BOX_VERSION
    subconfig.vm.hostname = "master"
    subconfig.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.name = "master"
      v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
      # 10 GB Drive
      v.customize ['createmedium', 'disk', '--filename', "/tmp/extra_disk_#{v.name}.vdi", '--size', 10 * 1024]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "/tmp/extra_disk_#{v.name}.vdi"]
    end
    subconfig.vm.network :private_network, ip: "10.0.0.10"
  end
  (1..NODE_COUNT).each do |i|
    # Padding number with zeroes
    # https://stackoverflow.com/questions/1543171/how-can-i-output-leading-zeros-in-ruby
    server_num = i.to_s.rjust(3, "0")
    config.vm.box = BOX_IMAGE
    config.vm.box_version = BOX_VERSION
    config.vm.define "dock-node-#{server_num}" do |node|
      node.vm.hostname = "dock-node-#{server_num}"
      node.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.name = "dock-node-#{server_num}"
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        # 10 GB Drive
        v.customize ['createmedium', 'disk', '--filename', "/tmp/extra_disk_#{v.name}.vdi", '--size', 10 * 1024]
        v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "/tmp/extra_disk_#{v.name}.vdi"]
      end
      node.vm.network :private_network, ip: "10.0.0.#{i + 10}"
      node.vm.provision "shell", inline: "echo hello from node #{i};hostname -I"
      node.vm.provision "shell", path: "docker/install-docker.sh"
      node.vm.provision "shell" do |sh|
        sh.path = "docker/add_user_to_docker_group.sh"
        sh.args = ["vagrant"]
      end
    end
  end

end
