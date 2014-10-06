# -*- mode: ruby -*-
# vi: set ft=ruby :

packages =%w[deb rpm]

require 'etc'
USER = Etc.getlogin

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  packages.each do |pkg_name|
    config.vm.define pkg_name do |pkg|

      # vagrant plugin install vagrant-cachier # http://fgrehm.viewdocs.io/vagrant-cachier
      if Vagrant.has_plugin?("vagrant-cachier")
        pkg.cache.scope = :box
      end

      if USER == 'mlavi'
        pkg.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'
      else
        pkg.vm.network :public_network
      end

      if pkg_name == 'deb'
        pkg.vm.box = "vbox_precise"
        pkg.vm.box_url = "http://files.vagrantup.com/precise64.box"
        pkg.vm.provision "shell", inline: "apt-get -y update & apt-get install -y puppet"
      else
        pkg.vm.box = "centos_6_5"
        pkg.vm.box_url = "https://vagrantcloud.com/nrel/CentOS-6.5-x86_64/version/4/provider/virtualbox.box"
      end

      pkg.vm.provision "puppet" do |puppet|
        puppet.module_path = "puppet_modules"
        puppet.manifests_path = "puppet_manifests"
        puppet.manifest_file = "default.pp"
        puppet.options = "--verbose --debug"
      end

      #pkg.vm.provision "shell", path: "test_pertino_client.sh"
    end
  end
end
