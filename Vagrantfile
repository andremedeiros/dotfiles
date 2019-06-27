Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/disco64"

  config.vm.synced_folder "#{ENV['HOME']}/src/", "/home/ubuntu/src"

  config.vm.provider "virtualbox" do |vm|
    vm.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]

    vm.memory = 4096
    vm.cpus = 2
  end
end
