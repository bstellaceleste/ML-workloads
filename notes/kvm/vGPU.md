# Set up NVIDIA vGPU: https://gitlab.com/polloloco/vgpu-proxmox/-/tree/master

## Prerequisites

1. Creating files for vGPU unlock
```
mkdir /etc/vgpu_unlock
touch /etc/vgpu_unlock/profile_override.toml
```

2. Creating files for systemd to load the vgpu_unlock-rs library when starting the nvidia vgpu services
```
mkdir /etc/systemd/system/{nvidia-vgpud.service.d,nvidia-vgpu-mgr.service.d}
echo -e "[Service]\nEnvironment=LD_PRELOAD=/opt/vgpu_unlock-rs/target/release/libvgpu_unlock_rs.so" > /etc/systemd/system/nvidia-vgpud.service.d/vgpu_unlock.conf
echo -e "[Service]\nEnvironment=LD_PRELOAD=/opt/vgpu_unlock-rs/target/release/libvgpu_unlock_rs.so" > /etc/systemd/system/nvidia-vgpu-mgr.service.d/vgpu_unlock.conf
```

3. Enabling IOMMU

Add this `intel_iommu=on iommu=pt` to the `GRUB_CMDLINE_LINUX_DEFAULT` in the `/etc/default/grub` file.


4. Loading required kernel modules and blacklisting the open source nvidia driver
```
echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" >> /etc/modules
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
```

5. Applying the kernel configs and reboot
```
sudo update-initramfs -u -k all
sudo reboot
```

## Installation

1. First, NVIDIA does not provide free vGPU drivers. You will need to register [here](https://enterpriseproductregistration.nvidia.com/?LicType=EVAL&ProductFamily=vGPU&ncid=em-news-525732)
<!-- https://www.nvidia.com/en-us/data-center/resources/vgpu-evaluation/ -->
NVIDIA provides a 90 days trial registration for enterprises (this means you shouldn't register using a free email provider like gmail.com. Better use companies' email address like @mcgill.ca, for example.


2. Once you get the confirmation email from NVIDIA, create your password and you will then be able to download the drivers. 
Make sure to download the latest version (Look at the video [here](https://gitlab.com/polloloco/vgpu-proxmox/-/tree/master), which shows how to filter the platform and platform version.).
Me, I downloaded NVIDIA-GRID-Linux-KVM-535.129.03-537.70.zip, which is Linux KVM 16.2.


3. After downloading, we need to extract the zip
```
mkdir Nvidia-Grid-Linux/ && unzip NVIDIA-GRID-Linux-KVM-535.129.03-537.70.zip -d Nvidia-Grid-Linux/
chmod +x ./Nvidia-Grid-Linux/Host_Drivers/NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm.run
``` 
Since our GPU HW (Tesla V100) is not in the [list](https://docs.nvidia.com/grid/gpus-supported-by-vgpu.html) of vgpu supported cards, we need to patch the executable using the [patch](https://gitlab.com/polloloco/vgpu-proxmox/-/blob/master/535.129.03.patch) provided by our [baseline guide](https://gitlab.com/polloloco/vgpu-proxmox/-/tree/master).

```
./Nvidia-Grid-Linux/Host_Drivers/NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm.run --apply-patch 535.129.03.patch
```

This will generate a new file: `NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm-custom.run` that we will further use.


4. We can now install the driver
`sudo ./Nvidia-Grid-Linux/NVIDIA-Linux-x86_64-535.129.03-vgpu-kvm-custom.run --dkms`

> You might have an error saying that you already have an nvidia driver installed. If so, just uninstall nivida and retry the installation:
```
sudo apt-get remove -y --purge '^nvidia-.*'
sudo apt-get remove -y --purge '^libnvidia-.*'
```

If you also get an erro related to the kernel Nouveau modeset, please do the following:
```
sudo vim /etc/modprobe.d/blacklist-nouveau.conf

Add this to the file:
blacklist nouveau
options nouveau modeset=0


sudo update-initramfs -u
sudo reboot
```

After the installation, we should reboot and probably reinstall `nvidia-docker2`
```
sudo apt install --reinstall -y nvidia-docker2
sudo systemctl daemon-reload
sudo systemctl restart docker
```

5. After rebooting, test your installation by running the command `nvidia-smi`

Verify the vGPU unlock worked: `mdevctl types` (if not installed, install mdevctl `sudo apt update && sudo apt install mdevctl`). Look at our [baseline guide](https://gitlab.com/polloloco/vgpu-proxmox/-/tree/master) to see what the output should look like.

If this command doesn't return any output, vGPU unlock isn't working.

Another command you can try to see if your card is recognized as being vgpu enabled is this one: `nvidia-smi vgpu`.


Now we should be able:
	* to start VMs with GPUs without the need of passthrough (i.e., GPUs are no longer attached to the VMs and not usable by the host)
	* create 2 VMs attaching the same GPUs (with the passthrough, this is not possible: if you install a VM with a given GPU, you cannot longer use it to create another VM) --> as we see further in this document, enabling vGPU is not sufficient; we should now use virt tool to learn how to create mediated devices and attach them to VMs so thay can share a GPU both between them and with the host


## Attaching a vGPU to a VM: https://documentation.suse.com/smart/virtualization-cloud/html/task-assign-pci-device-libvirt/index.html 

> This technique does attach the GPU exclusively to the VM, ie, once attached, the GPU is no longer seen by the host and cannot be used by another VM

1. On the guest side: you shoudl update the grub to activate iommu (as in the host) and perfom #Prerequisite-4

2. Find out which GPU the host is using: `lshw -C display`. The *bus info* line provides the bus id we'll use.

3. Get the domain, bus, and function values of the device: `sudo virsh nodedev-dumpxml pci_0000_03_07_0`

4. Detach the device from the host: `sudo virsh nodedev-detach pci_id`

5. Switch off the VM and edit the domain to add the device infos:
```
virsh edi *domain_id*

add the following to the <devices> section
<hostdev mode='subsystem' type='pci' managed='yes'>
  <source>
    <address domain='xxx' bus='xxx' slot='xxx' function='xxx'/>
  </source>
</hostdev>
```

When you reboot the VM, verify that the system detects the device using `lspci -d 10de: -k`

## Sharing GPUs between VMs and Host (Full Virtualization!!)
