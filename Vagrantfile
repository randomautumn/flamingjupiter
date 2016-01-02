# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "worthytemple" do |box|
    box.vm.box = "Skilled Drill"
    box.vm.network "forwarded_port", guest: 26646, host: 25670
    box.ssh.username="vagrant"
    box.ssh.private_key_path="/Users/emorymerryman/.ssh/xvIpSE0A_id_rsa"
    box.ssh.forward_x11="yes"
    box.vm.provision :shell, path: "provisioners/worthytemple.sh"
  end
  config.vm.define "smalljazz" do |box|
    box.vm.box = "Skilled Drill"
    box.vm.network "forwarded_port", guest: 26647, host: 25671
    box.ssh.username="vagrant"
    box.ssh.private_key_path="/Users/emorymerryman/.ssh/xvIpSE0A_id_rsa"
    box.ssh.forward_x11="yes"
    box.vm.provision :shell, path: "provisioners/smalljazz.sh"
  end
  config.vm.define "gitlab" do |box|
    box.vm.box = "Skilled Drill"
    config.vm.network "private_network", ip: "192.168.50.201"
    box.vm.network "forwarded_port", guest: 80, host: 25672
    box.vm.network "forwarded_port", guest: 80, host: 25673
    box.vm.network "forwarded_port", guest: 80, host: 25674
    box.vm.network "forwarded_port", guest: 22, host: 21393
    box.ssh.username="vagrant"
    box.ssh.private_key_path="/Users/emorymerryman/.ssh/xvIpSE0A_id_rsa"
    box.ssh.forward_x11="yes"
    box.vm.provision :shell, path: "provisioners/gitlab.sh"
  end
  config.vm.define "jenkins" do |box|
    box.vm.box = "Skilled Drill"
    config.vm.network "private_network", ip: "192.168.50.202"
    box.vm.network "forwarded_port", guest: 8080, host: 25675
    box.vm.network "forwarded_port", guest: 8080, host: 25676
    box.vm.network "forwarded_port", guest: 8080, host: 25677
    box.vm.network "forwarded_port", guest: 22, host: 21394
    box.ssh.username="vagrant"
    box.ssh.private_key_path="/Users/emorymerryman/.ssh/xvIpSE0A_id_rsa"
    box.ssh.forward_x11="yes"
    box.vm.provision :shell, path: "provisioners/jenkins.sh"
  end
  config.vm.define "git" do |box|
    box.vm.box = "Skilled Drill"
    box.vm.network "forwarded_port", guest: 22, host: 25674
    box.ssh.username="vagrant"
    box.ssh.private_key_path="/Users/emorymerryman/.ssh/xvIpSE0A_id_rsa"
    box.ssh.forward_x11="yes"
    box.vm.provision :shell, path: "provisioners/git.sh"
  end
end
#