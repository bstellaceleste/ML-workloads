sudo virt-install --virt-type=kvm --name mlsys --ram 409600 --vcpus=60 --os-variant=ubuntu18.04 --hvm --network=bridge:virbr0,model=virtio --host-device 89:00.0 --host-device 8a:00.0 --nographics --disk path=mlsys.img,size=50,format=raw,bus=virtio --import