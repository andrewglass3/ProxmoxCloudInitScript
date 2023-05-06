## ProxmoxCloudInitScript ##

### This script creates an Ubuntu 22.04 template for quick creation of virtual machines in Proxmox VE. ###

### Instructions ###

* SSH into the Proxmox VE server and run as root or a user with admin permissions.

* Clone the script from this repo.

* Modify the variables section to your needs as per the instructions below:

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

* ``` templateName="jammy-tpl" ``` This variable is used to set the name of the template as it appears in the datacentre > pve > list on in the column on the left side of the proxmox web ui. 

* ``` tmp_cores="2" ``` Use of this variable configures the number of cpu cores you wish to add to your vm template.

* ``` tmp_memory="2048" ``` Set the amount of memory in the vm template via this variable. 

* Set the root password before running this script via the variable  ``` rootPassword="password" ``` 

* I set the ethernet adapter of the vm to dhcp during setup via the command - ``` qm set $virtualMachineId --ipconfig0 ip=dhcp ``` 

* Should you wish to set the ethernet adapter to static modify the command quoted above inside the script to use a valid ip/subnet and gateway for example  ``` qm set $virtualMachineId  --ipconfig0 ip=10.10.10.222/24,gw=10.10.10.1 ``` 

* The cpu type is set to host as this allows passthrough of cpu properties eg AES-NI MMX etc if you wish to change please modify the variable ``` cpuTypeRequired="host" ```
  Examples includ ```cpuTypeRequired="kvm64" ``` ``` cpuTypeRequired="qemu64" ``` etc.

* Once this script finishes - on the left column in Proxmox you will see 9000 jammy-tpl - this is your vm template - right click and select clone.  

* On the popup box that appears - select mode = full clone, give the vm a name and select where you want to store the new vm you are creating .

* Once the new vm appears in the left column - start the vm and open the console - please be aware that you will only see a single line of output at the top of the console.

* This will last for about 30 seconds  whilst it builds and boots the vm, once booted you will see the login prompt - use the root user with the password you set in the script to login.  

### Ensure you change the default password on initial login if you didnt change it during the script execution. ###
