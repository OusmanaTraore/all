Vagrant.require_version ">= 2.0.0"

boxes = [
    {
        :name => "control-plane",
        :eth1 => "192.168.56.45",
        :mem => "4096",
        :cpu => "2"
    },

    {
        :name => "node1",
        :eth1 => "192.168.56.46",
        :mem => "2048",
        :cpu => "1"
    },

    {
        :name => "node2",
        :eth1 => "192.168.56.47",
        :mem => "2048",
        :cpu => "1"
    },
   {
        :name => "node3",
        :eth1 => "192.168.56.48",
        :mem => "2048",
        :cpu => "1"
    }
]

Vagrant.configure(2) do |config|
    config.vm.box ="bento/ubuntu-20.04"
  
    boxes.each do |opts|
        config.vm.define opts[:name] do |config|
          config.vm.provision "shell" , inline: <<-SHELL
          echo machine launched
          SHELL
          
          config.vm.hostname = opts[:name]
          config.vm.provider "virtualbox" do |v|
            v.customize ["modifyvm", :id, "--memory", opts[:mem]]
            v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
          end
          config.vm.network :private_network, ip: opts[:eth1]
        end
    end
end
