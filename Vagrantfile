# -*- mode: ruby -*-
# vi: set ft=ruby :

$install_packages_script = <<SCRIPT
pacman -Sy --noconfirm --needed base-devel
SCRIPT

$disk_setup = <<SCRIPT
# Cleanup process in case this has already been done
if [ -d $2 ]; then
  umount -R $2
  rm -rf $2
fi

if [ -L /tools ]; then
  unlink /tools
fi

sed '/# BEGIN - Secondary disk configuration/,/# END - Secondary disk configuration/d' -i /etc/fstab

# Create the partition layout
sfdisk /dev/sdb -uM << DISK_TABLE
,$1
;
DISK_TABLE

# Format some filesystems
mkfs -t ext2 /dev/sdb1
mkfs -t ext4 -L build_dir /dev/sdb2

# Insert the new partitions into our fstab
cat >> /etc/fstab << FSTAB
# BEGIN - Secondary disk configuration

# /dev/sdb2
UUID=$(blkid -s UUID -o value /dev/sdb2)      $2          ext4            rw,relatime,data=ordered        0 3

# /dev/sdb1
UUID=$(blkid -s UUID -o value /dev/sdb1)      $2/boot     ext2            rw,relatime                     0 4

# Sources
/vagrant/sources                              $2/sources  none            bind                            0 0

# END - Secondary disk configuration
FSTAB

# Create mountpoints and mount them
for d in $2/{,boot,sources}; do
  mkdir $d
  mount $d
done

# Create the working directory
install -d -o vagrant -m 777 $2/build

# Create the target toolchain directory and symlink
install -d -o vagrant $2/tools
ln -sv $2/tools /
SCRIPT

$setup_environment = <<SCRIPT
cat > ~vagrant/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\\u:\w\$ ' /bin/bash
EOF

cat > ~vagrant/.bashrc << EOF
set +h
umask 022
LFS=$(mount | grep `blkid -L build_dir` | cut -d' ' -f3)
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/tools/bin:/bin:/usr/bin
MAKEFLAGS='-j $(nproc)'
export LFS LC_ALL LFS_TGT PATH MAKEFLAGS
EOF
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Root path of this vagrant instance
VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ogarcia/archlinux-201408-x64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # View the documentation for the provider you're using for more
  # information on available options.
  
  config.vm.provider "virtualbox" do |vb|
  #  # Don't boot with headless mode
  #  vb.gui = true

    vb.memory = 1024
    vb.cpus = 2

    # Size of the disk in gigabytes
    disk_size = 10 * 1024

    # Path of the additional disk
    disk_path = File.join(VAGRANT_ROOT, '.vagrant', 'box-disk2.vdi')

    unless File.exist?(disk_path)
      vb.customize ['createhd', '--filename', disk_path, '--size', disk_size]
    end

    vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk_path]
  end

  config.vm.provision "shell", inline: $install_packages_script

  config.vm.provision "shell" do |s|
    s.inline = $disk_setup
    s.args = "128 /mnt/build_dir"
  end

  config.vm.provision "shell", inline: $setup_environment
end
