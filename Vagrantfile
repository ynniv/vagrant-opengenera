# -*- mode: ruby; -*-

Vagrant::Config.run do |config|
  config.vm.box = "ubuntu-8.04.4-server-amd64"
  config.vm.customize [
    "modifyvm", :id,
    "--memory", "1024"
  ]

  config.vm.forward_port 5901, 5902

  # Enable and configure the chef solo provisioner
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"

    # the magic
    chef.add_recipe("opengenera")
  end
end
