def is_arm64()
    `uname -m` == "arm64"
end

Vagrant.configure("2") do |config|
    if is_arm64()
        config.cm.box = 'bento/ubuntu-22.04-arm64'
    else
        config.vm.box = 'generic/ubuntu2204'
    end

    config.vm.synced_folder ".", "/vagrant", id: "vagrant", disabled: false, automount: true
    config.vm.hostname = "dev"
    config.vm.disk :disk, size: "100GB", primary: true

    config.vm.network :forwarded_port, guest: 80, host: 80, auto_correct: true
    config.vm.network :forwarded_port, guest: 443, host: 443, auto_correct: true

    if Vagrant.has_plugin?("vagrant-timezone")
        config.timezone.value = :host
    end

    config.vm.provision "ansible_local" do |ansible|
        ansible.version = "latest"
        ansible.playbook = "local.yml"
    end
	
    config.vm.provision "reboot", type: "shell", inline: "sudo apt update; sudo apt full-upgrade -y; sudo usermod -p `openssl passwd -1  -salt 5RPVAd asdf` vagrant", reboot: true
	
    config.vm.provider "vmware_workstation"
    config.vm.provider "vmware_fusion"
    config.vm.provider "virtualbox"

    config.vm.provider "vmware_workstation" do |v|
        v.gui = true
        v.memory = 53248
        v.cpus = 16
	v.linked_clone = false
    end

    config.vm.provider "vmware_fusion" do |v|
        v.linked_clone = false
        v.gui = true
        v.memory = 16384
        v.cpus = 8
    end

    config.vm.provider "virtualbox" do |v|
        v.memory = 53248
        v.cpus = 16
    end
end
