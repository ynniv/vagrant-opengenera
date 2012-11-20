#http://adrianbravo.tumblr.com/post/644860401

date > /etc/vagrant_box_build_time

# Apt-install various things necessary for Ruby, guest additions,
# etc., and remove optional things to trim down the machine.
apt-get -y update
apt-get -y upgrade
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev nfs-common
apt-get -y install vim
apt-get clean

#Installing the virtualbox guest additions
echo "Installing the virtualbox guest additions"
apt-get -y install dkms
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso
echo "completed virtualbox guest additions"

# Install NFS client
apt-get -y install nfs-common

#Setting up sudo
echo "setting up sudo"
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers
echo "completed setting up sudo"

# Install Ruby from source in /opt so that users of Vagrant
# can install their own Rubies using packages or however.
echo "installing ruby"
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
tar xzf ruby-1.9.2-p290.tar.gz
cd ruby-1.9.2-p290
./configure --prefix=/opt/ruby
make
make install
cd ..
rm -rf ruby-1.9.2-p290
rm -f ruby-1.9.2-p290.tar.gz

# Install RubyGems 1.7.2
wget http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz
tar xzf rubygems-1.8.24.tgz
cd rubygems-1.8.24
/opt/ruby/bin/ruby setup.rb
cd ..
rm -rf rubygems-1.8.24
rm -f rubygems-1.8.24.tgz

# Add /opt/ruby/bin to the global path as the last resort so
# Ruby, RubyGems, and Chef/Puppet are visible
echo 'PATH=$PATH:/opt/ruby/bin/'> /etc/profile.d/vagrantruby.sh
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
apt-get -y remove linux-headers-$(uname -r) build-essential
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
