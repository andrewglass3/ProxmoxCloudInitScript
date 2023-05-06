## ProxmoxCloudInitScript ##

### This script creates an Ubuntu 22.04 template for quick creation of virtual machines in Proxmox VE. ###

### Useful Links: ###

https://proxmox.com/en/ < Get Promox VE from here.

https://cloud-images.ubuntu.com/ < Get Ubuntu Cloud Init images from here.

https://forum.proxmox.com/ < Proxmox Community Forum.



### Instructions ###

* SSH into the Proxmox VE server and run as root or a user with admin permissions.

* Clone the script from this repo.

* Modify the variables section to your needs as per the instructions below.

* We install libguestfs-tools after updating and upgrading the base Ubuntu packages as this is package is needed to be able to run the ``` virt-customize ``` commands.

* Give the script execute permissions ``` chmod +x create-ubuntu-jammy-template.sh ```

* Finally run the script ``` ./create-ubuntu-jammy-template.sh ```

### A copy of the script being run on my pve host is located at the bottom of this page for information. ###


### Variables ###

``` 
imageURL=https://cloud-images.ubuntu.com/jammy/20230504/jammy-server-cloudimg-amd64.img
imageName="jammy-server-cloudimg-amd64.img"
volumeName="local-lvm"
virtualMachineId="9000"
templateName="jammy-tpl"
tmp_cores="2"
tmp_memory="2048"
rootPasswd="password"
cpuTypeRequired="host"
```

* The variable ```imageURL=https://cloud-images.ubuntu.com/jammy/20230504/jammy-server-cloudimg-amd64.img``` is the url from which to download the cloud init image from Ubuntu. Should you which to change to a different image please visit https://cloud-images.ubuntu.com/ Then download the .img suitable for your proxmox host/cpu needs.

* ``` imageName="jammy-server-cloudimg-amd64.img ``` Use this variable to give the image you downloaded from www.cloud-images.ubuntu.com a name for use during the script.

* The variable ``` VolumeName="local-lvm" ``` should match the name of your local storage on the left column in proxmox which you use for the storage location of the vm disk. See Image below:
<img width="335" alt="image" src="https://user-images.githubusercontent.com/7479585/236636540-e8afb170-f603-4a64-a837-965e139e66ab.png">


* ``` virtualMachineId="9000" ``` When setting this variable value - please ensure that it uses an id number that is not already in use as it will be over written by this script. Since my vms are in the low 100's Ive set this value to an obviously high number.

* ``` templateName="jammy-tpl" ``` This variable is used to set the name of the template as it appears in the datacentre > pve > list on in the column on the left side of the proxmox web ui as you can see in the image above.

* ``` tmp_cores="2" ``` Use of this variable configures the number of cpu cores you wish to add to your vm template.

* ``` tmp_memory="2048" ``` Set the amount of memory in the vm template via this variable. 

* Set the root password before running this script via the variable  ``` rootPassword="password" ``` 

* I set the ethernet adapter of the vm to dhcp during setup via the command - ``` qm set $virtualMachineId --ipconfig0 ip=dhcp ``` 

* Should you wish to set the ethernet adapter to static modify the command quoted above inside the script to use a valid ip/subnet and gateway for example  ``` qm set $virtualMachineId  --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1 ``` 

* The cpu type is set to host as this allows passthrough of cpu properties eg AES-NI MMX etc if you wish to change please modify the variable ``` cpuTypeRequired="host" ```
  Examples include ```cpuTypeRequired="kvm64" ``` ``` cpuTypeRequired="qemu64" ``` etc.

* Once this script finishes - on the left column in Proxmox you will see 9000 jammy-tpl - this is your vm template - right click and select clone.  

* On the popup box that appears - select mode = full clone, give the vm a name and select where you want to store the new vm you are creating - see image below:

<img width="626" alt="image" src="https://user-images.githubusercontent.com/7479585/236637155-b03e45d0-6954-4d63-af5f-362d07d8e943.png">


* Once the new vm appears in the left column - start the vm and open the console - please be aware that you may only see a single line of output at the top of the console on initial boot.

* This will last for about 30 seconds  whilst it builds and boots the vm, once booted you will see the login prompt - use the root user with the password you set in the script to login.  

### Ensure you change the default password on initial login if you didnt change it during the script execution. I have set the root password in this script to ``` password ``` ###

### Script output after running on my personal Proxmox VE host ###

```
root@pve:~# ./create-ubuntu-jammy-template.sh
Hit:1 http://security.debian.org bullseye-security InRelease
Hit:2 http://ftp.uk.debian.org/debian bullseye InRelease
Hit:3 http://download.proxmox.com/debian/pve bullseye InRelease
Hit:4 http://ftp.uk.debian.org/debian bullseye-updates InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
All packages are up to date.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
libguestfs-tools is already the newest version (1:1.44.0-2).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
--2023-05-06 17:25:21--  https://cloud-images.ubuntu.com/jammy/20230504/jammy-server-cloudimg-amd64.img
Resolving cloud-images.ubuntu.com (cloud-images.ubuntu.com)... 185.125.190.40, 185.125.190.37, 2620:2d:4000:1::17, ...
Connecting to cloud-images.ubuntu.com (cloud-images.ubuntu.com)|185.125.190.40|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 689176576 (657M) [application/octet-stream]
Saving to: ‘jammy-server-cloudimg-amd64.img’

jammy-server-cloudimg-amd64.img           100%[====================================================================================>] 657.25M  71.6MB/s    in 9.5s    

2023-05-06 17:25:31 (69.0 MB/s) - ‘jammy-server-cloudimg-amd64.img’ saved [689176576/689176576]

  Logical volume "vm-9000-cloudinit" successfully removed
  Logical volume "base-9000-disk-0" successfully removed
[   0.0] Examining the guest ...
[   3.9] Setting a random seed
virt-customize: warning: random seed could not be set for this type of 
guest
[   3.9] Setting the machine ID in /etc/machine-id
[   3.9] Installing packages: qemu-guest-agent
[  17.6] Finishing off
[   0.0] Examining the guest ...
[   3.6] Setting a random seed
virt-customize: warning: random seed could not be set for this type of 
guest
[   3.7] Setting passwords
[   4.6] Finishing off
importing disk 'jammy-server-cloudimg-amd64.img' to VM 9000 ...
  Logical volume "vm-9000-disk-0" created.
transferred 0.0 B of 2.2 GiB (0.00%)
transferred 22.5 MiB of 2.2 GiB (1.00%)
transferred 45.0 MiB of 2.2 GiB (2.00%)
transferred 67.6 MiB of 2.2 GiB (3.00%)
transferred 90.1 MiB of 2.2 GiB (4.00%)
transferred 112.6 MiB of 2.2 GiB (5.00%)
transferred 135.1 MiB of 2.2 GiB (6.00%)
transferred 159.0 MiB of 2.2 GiB (7.06%)
transferred 181.5 MiB of 2.2 GiB (8.06%)
transferred 204.0 MiB of 2.2 GiB (9.06%)
transferred 226.6 MiB of 2.2 GiB (10.06%)
transferred 249.1 MiB of 2.2 GiB (11.06%)
transferred 271.6 MiB of 2.2 GiB (12.06%)
transferred 294.1 MiB of 2.2 GiB (13.06%)
transferred 316.6 MiB of 2.2 GiB (14.06%)
transferred 339.2 MiB of 2.2 GiB (15.06%)
transferred 361.7 MiB of 2.2 GiB (16.06%)
transferred 384.2 MiB of 2.2 GiB (17.06%)
transferred 406.9 MiB of 2.2 GiB (18.07%)
transferred 429.5 MiB of 2.2 GiB (19.07%)
transferred 452.0 MiB of 2.2 GiB (20.07%)
transferred 474.5 MiB of 2.2 GiB (21.07%)
transferred 497.0 MiB of 2.2 GiB (22.07%)
transferred 519.5 MiB of 2.2 GiB (23.07%)
transferred 542.1 MiB of 2.2 GiB (24.07%)
transferred 564.6 MiB of 2.2 GiB (25.07%)
transferred 587.1 MiB of 2.2 GiB (26.07%)
transferred 609.6 MiB of 2.2 GiB (27.07%)
transferred 632.1 MiB of 2.2 GiB (28.07%)
transferred 654.7 MiB of 2.2 GiB (29.07%)
transferred 677.2 MiB of 2.2 GiB (30.07%)
transferred 699.7 MiB of 2.2 GiB (31.07%)
transferred 722.2 MiB of 2.2 GiB (32.07%)
transferred 744.7 MiB of 2.2 GiB (33.07%)
transferred 767.3 MiB of 2.2 GiB (34.07%)
transferred 789.8 MiB of 2.2 GiB (35.07%)
transferred 812.3 MiB of 2.2 GiB (36.07%)
transferred 834.8 MiB of 2.2 GiB (37.07%)
transferred 857.3 MiB of 2.2 GiB (38.07%)
transferred 879.9 MiB of 2.2 GiB (39.07%)
transferred 902.4 MiB of 2.2 GiB (40.07%)
transferred 924.9 MiB of 2.2 GiB (41.07%)
transferred 947.4 MiB of 2.2 GiB (42.07%)
transferred 969.9 MiB of 2.2 GiB (43.07%)
transferred 992.5 MiB of 2.2 GiB (44.07%)
transferred 1015.0 MiB of 2.2 GiB (45.07%)
transferred 1.0 GiB of 2.2 GiB (46.07%)
transferred 1.0 GiB of 2.2 GiB (47.07%)
transferred 1.1 GiB of 2.2 GiB (48.07%)
transferred 1.1 GiB of 2.2 GiB (49.07%)
transferred 1.1 GiB of 2.2 GiB (50.07%)
transferred 1.1 GiB of 2.2 GiB (51.07%)
transferred 1.1 GiB of 2.2 GiB (52.07%)
transferred 1.2 GiB of 2.2 GiB (53.07%)
transferred 1.2 GiB of 2.2 GiB (54.07%)
transferred 1.2 GiB of 2.2 GiB (55.07%)
transferred 1.2 GiB of 2.2 GiB (56.07%)
transferred 1.3 GiB of 2.2 GiB (57.07%)
transferred 1.3 GiB of 2.2 GiB (58.07%)
transferred 1.3 GiB of 2.2 GiB (59.07%)
transferred 1.3 GiB of 2.2 GiB (60.07%)
transferred 1.3 GiB of 2.2 GiB (61.07%)
transferred 1.4 GiB of 2.2 GiB (62.07%)
transferred 1.4 GiB of 2.2 GiB (63.07%)
transferred 1.4 GiB of 2.2 GiB (64.07%)
transferred 1.4 GiB of 2.2 GiB (65.08%)
transferred 1.5 GiB of 2.2 GiB (66.08%)
transferred 1.5 GiB of 2.2 GiB (67.08%)
transferred 1.5 GiB of 2.2 GiB (68.08%)
transferred 1.5 GiB of 2.2 GiB (69.08%)
transferred 1.5 GiB of 2.2 GiB (70.08%)
transferred 1.6 GiB of 2.2 GiB (71.08%)
transferred 1.6 GiB of 2.2 GiB (72.08%)
transferred 1.6 GiB of 2.2 GiB (73.08%)
transferred 1.6 GiB of 2.2 GiB (74.15%)
transferred 1.7 GiB of 2.2 GiB (75.21%)
transferred 1.7 GiB of 2.2 GiB (76.21%)
transferred 1.7 GiB of 2.2 GiB (77.32%)
transferred 1.7 GiB of 2.2 GiB (78.33%)
transferred 1.7 GiB of 2.2 GiB (79.33%)
transferred 1.8 GiB of 2.2 GiB (80.34%)
transferred 1.8 GiB of 2.2 GiB (81.42%)
transferred 1.8 GiB of 2.2 GiB (82.45%)
transferred 1.8 GiB of 2.2 GiB (83.45%)
transferred 1.9 GiB of 2.2 GiB (84.45%)
transferred 1.9 GiB of 2.2 GiB (85.45%)
transferred 1.9 GiB of 2.2 GiB (86.45%)
transferred 1.9 GiB of 2.2 GiB (87.55%)
transferred 1.9 GiB of 2.2 GiB (88.64%)
transferred 2.0 GiB of 2.2 GiB (89.73%)
transferred 2.0 GiB of 2.2 GiB (90.76%)
transferred 2.0 GiB of 2.2 GiB (91.79%)
transferred 2.0 GiB of 2.2 GiB (92.79%)
transferred 2.1 GiB of 2.2 GiB (93.82%)
transferred 2.1 GiB of 2.2 GiB (94.87%)
transferred 2.1 GiB of 2.2 GiB (95.87%)
transferred 2.1 GiB of 2.2 GiB (96.94%)
transferred 2.2 GiB of 2.2 GiB (97.94%)
transferred 2.2 GiB of 2.2 GiB (98.99%)
transferred 2.2 GiB of 2.2 GiB (99.99%)
transferred 2.2 GiB of 2.2 GiB (100.00%)
transferred 2.2 GiB of 2.2 GiB (100.00%)
Successfully imported disk as 'unused0:local-lvm:vm-9000-disk-0'
update VM 9000: -scsi0 local-lvm:vm-9000-disk-0 -scsihw virtio-scsi-pci
update VM 9000: -boot c -bootdisk scsi0
update VM 9000: -ide2 local-lvm:cloudinit
  Logical volume "vm-9000-cloudinit" created.
ide2: successfully created disk 'local-lvm:vm-9000-cloudinit,media=cdrom'
generating cloud-init ISO
update VM 9000: -serial0 socket -vga serial0
update VM 9000: -ipconfig0 ip=dhcp
update VM 9000: -cpu cputype=host
  Renamed "vm-9000-disk-0" to "base-9000-disk-0" in volume group "pve"
  Logical volume pve/base-9000-disk-0 changed.
 
  ```
