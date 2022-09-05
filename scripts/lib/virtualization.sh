#! /bin/env bash

##----------------------- VMWare ---------------------##

# The vmware section will install the tools and then setup the folder sharing and
# permissions. Cut and paste capability between the host and the server will also
# be setup.

# vm share dir
share_dir="sharefs"

# Create the filesystem
# check if the dir already exists
if [ -d "$share_dir" ]
then
   echo "$share_dir does not exist, creating it"
   mkdir /mnt/$share_dir
else
   echo "The directory already exists"
fi



# make sure the mount point exists
# Mount the filesystem for usage in this current session
if grep -qs "/mnt/$share_dir " /proc/mounts; then
    echo "The share has already been mounted"
else
    sudo mount -t fuse.vmhgfs-fuse .host:/ "/mnt/$share_dir" -o allow_other
fi



# Add to /etc/fstab for persistence
# check if it already exists
share=$(grep "/mnt/$share_dir" /etc/fstab)

if [[ $share == "" ]]; then
    echo ".host:/ "/mnt/$share_dir" fuse.vmhgfs-fuse allow_other 0 0" >> /etc/fstab
else
    echo "This has already been set to auto mount"
fi




install_vmware_tools() {
  echo "Installing vmware the tools"

  local pkgs=("open-vm-tools")
}

configure_shared_folders() {
  sudo echo ".host:/VM_Data /mnt/VM_Data fuse.vmhgfs-fuse nofail,allow_other 0 0" >> /etc/fstab
  sudo echo ".host:/Downloads /mnt/Downloads fuse.vmhgfs-fuse nofail,allow_other 0 0" >> /etc/fstab
}

#configure_vmware() {
#  echo "setting up cut and paste"
#}

#create_shared_drive() {
#  echo "create the shared folder"
#}

#sudo mkinitcpio -P

#sudo mkdir -p /mnt/VM_Data



#add the following two lines to /etc/fstab


# sudo vmhgfs-fuse -o allow_other -o auto_unmount .host:/<shared_folder> <shared folders root directory>
#/etc/fstab
#.host:/$shared_folder $shared_folders_root_directory fuse.vmhgfs-fuse nofail,allow_other 0 0

#echo ".host:VM_Data /mnt/sharefs fuse.vmhgfs-fuse allow_other 0 0" >>/etc/fstab

# remind me to install binary ninja by hand by openning a browser at the end with some tabs??

#/etc/systemd/system/ <shared folders root directory >- <shared_folder >.service
#[Unit]
#Description=Load VMware shared folders
#Requires=vmware-vmblock-fuse.service
#After=vmware-vmblock-fuse.service
#ConditionPathExists=.host:/$shared_folder
#ConditionVirtualization=vmware

#[Service]
#Type=oneshot
#RemainAfterExit=yes
#ExecStart=/usr/bin/vmhgfs-fuse -o allow_other -o auto_unmount .host:/$shared_folder $shared_folders_root_directory

#[Install]
#WantedBy=multi-user.target

#systemctl enable VM_Data.service

#need cut and paste from host to vm

create_share() {
  # Create the filesystem

  local ans=""
  echo "Would you like to setup sharing and cut/paste between the host and this vm? [Y/n]"

  read -r ans
  if [[ $ans == "" ]] || [[ $ans == "Y" ]]; then

    # check if the dir already exists
    if [ -d "$share_dir" ]; then
      echo "$share_dir does not exist, creating it"
      mkdir /mnt/$share_dir
    else
      echo "The directory already exists"
    fi

    # make sure the mount point exists
    # Mount the filesystem for usage in this current session
    if grep -qs '/mnt/sharefs ' /proc/mounts; then
      echo "The share has already been mounted"
    else
      mount -t fuse.vmhgfs-fuse .host:/ /mnt/sharefs -o allow_other
    fi

    # Add to /etc/fstab for persistence check if it already exists
    local share=""
    share=$(grep "/mnt/$share_dir" /etc/fstab)

    if [[ $share == "" ]]; then
      echo ".host:/ /mnt/sharefs fuse.vmhgfs-fuse allow_other 0 0" >>/etc/fstab
    else
      echo "This has already been set to auto mount"
    fi
    return 0
  else
    echo "Sharing not configured"
    return 0
  fi
}

