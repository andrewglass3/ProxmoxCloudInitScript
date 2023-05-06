## Notes ##
#
#  VolumeName="local-lvm" should match the name of your local storage on the left column in proxmox which you use for the storage location of the vm disk  #
#  Set the root password before running this script via the variable  ``` rootPassword="password" ``` #
#  Set the ethernet adapter of the vm to dhcp during setup via the command - ``` qm set $virtualMachineId --ipconfig0 ip=dhcp ``` #
#  Should you wish to set this to static change this line  in the script to a valid ip/subnet for example  ``` qm set $virtualMachineId  --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1 ``` #
#
# Once this script finishes - on the left column in Proxmox you will see 9000 jammy-tpl - this is your vm template - right click and select clone #
# On the popup box that appears - select mode = full clone, give the vm a name and select where you want to store the new vm you are creating . #
# Once the new vm appears in the left column - start the vm and open the console - please be aware that you will only see a single line of output at the top of the console #
# This will last for about 30 seconds  whilst it builds and boots the vm, once booted you will see the login prompt - use the root user with the password you set in the script to login #

## End of Notes ##

imageURL=https://cloud-images.ubuntu.com/jammy/20230504/jammy-server-cloudimg-amd64.img
imageName="jammy-server-cloudimg-amd64.img"
volumeName="local-lvm"
virtualMachineId="9000"
templateName="jammy-tpl"
tmp_cores="2"
tmp_memory="2048"
rootPasswd="password"

apt update && apt upgrade -y
apt install libguestfs-tools -y
rm *.img
wget -O $imageName $imageURL
qm destroy $virtualMachineId
virt-customize -a $imageName --install qemu-guest-agent
virt-customize -a $imageName --root-password password:$rootPasswd
qm create $virtualMachineId --name $templateName --memory $tmp_memory --cores $tmp_cores --net0 virtio,bridge=vmbr0
qm importdisk $virtualMachineId $imageName $volumeName
qm set $virtualMachineId --scsihw virtio-scsi-pci --scsi0 $volumeName:vm-$virtualMachineId-disk-0
qm set $virtualMachineId --boot c --bootdisk scsi0
qm set $virtualMachineId --ide2 $volumeName:cloudinit
qm set $virtualMachineId --serial0 socket --vga serial0
qm set $virtualMachineId --ipconfig0 ip=dhcp
qm set $virtualMachineId --cpu cputype=host
qm template $virtualMachineId