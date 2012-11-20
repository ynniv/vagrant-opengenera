#http://adrianbravo.tumblr.com/post/644860401

date > /etc/vagrant_box_build_time

#Installing the virtualbox guest additions
echo "Installing the virtualbox guest additions"
apt-get -y install dkms linux-kernel-devel linux-source linux-headers-$(uname -r) build-essential
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso
echo "completed virtualbox guest additions"

#Updating the box
echo "Updating the box"
apt-get -y update
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev nfs-common
apt-get clean
echo "completed updating the box"

#Setting up sudo
echo "setting up sudo"
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
echo "completed setting up sudo"

#Installing ruby
echo "installing ruby"
wget http://rubyforge.org/frs/download.php/71096/ruby-enterprise-1.8.7-2010.02.tar.gz
tar xzf ruby-enterprise-1.8.7-2010.02.tar.gz
./ruby-enterprise-1.8.7-2010.02/installer -a /opt/ruby --no-dev-docs --dont-install-useful-gems
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/rubyenterprise.sh
rm -rf ./ruby-enterprise-1.8.7-2010.02/
rm ruby-enterprise-1.8.7-2010.02.tar.gz
echo "completed installating ruby"

#Installing chef & Puppet
echo "installing chef and puppet"
/opt/ruby/bin/gem install chef --no-ri --no-rdoc
/opt/ruby/bin/gem install puppet --no-ri --no-rdoc
echo "completed installing chef and puppet"

#Installing vagrant keys
echo "installing vagrant keys"
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
echo "completed installing vagrant keys"

# Remove items used for building, since they aren't needed anymore
echo "removing development packages"
apt-get -y remove linux-kernel-devel linux-headers-$(uname -r) build-essential
apt-get -y autoremove
echo "completed removing development packages"

# Not sure if this is needed for hardy too
# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

exit
