# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "worthytemple" do |box|
    box.vm.box = "Skilled Drill"
    box.vm.network "forwarded_port", guest: 26646, host: 25670
    box.ssh.username="vagrant"
    box.ssh.private_key_path="/Users/emorymerryman/.ssh/xvIpSE0A_id_rsa"
    box.ssh.forward_x11="yes"
    box.vm.provision :shell, path: "scripts/worthytemple.sh"
  end
end
