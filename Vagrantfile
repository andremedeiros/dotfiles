Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/disco64"

  config.vm.synced_folder "#{ENV['HOME']}/src/", "/home/ubuntu/src"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
end
