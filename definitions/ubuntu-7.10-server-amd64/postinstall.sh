#http://adrianbravo.tumblr.com/post/644860401

set -e

echo "POSTINSTALL BEGIN"

date > /etc/vagrant_box_build_time

# ideally this would be excluded in the preseed
sed -i.bak 's/^.*cdrom.*$//g' /etc/apt/sources.list
apt-get -y update

cat /etc/apt/sources.list
apt-cache search linux-headers
apt-cache search zlib1g-dev

#Updating the box
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev nfs-common
apt-get clean

#Setting up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

#Installing ruby
#wget http://rubyforge.org/frs/download.php/71096/ruby-enterprise-1.8.7-2010.02.tar.gz
RUBY_VERSION=ruby-enterprise-1.8.7-2012.02
wget http://rubyenterpriseedition.googlecode.com/files/${RUBY_VERSION}.tar.gz
tar xzvf ${RUBY_VERSION}.tar.gz
mkdir -p /opt/ruby/lib/ruby/gems/1.8/gems
./${RUBY_VERSION}/installer -a /opt/ruby --no-dev-docs --dont-install-useful-gems
echo 'PATH=$PATH:/opt/ruby/bin/'>> /etc/profile
rm -rf ./${RUBY_VERSION}/
rm ${RUBY_VERSION}.tar.gz

#Installing chef & Puppet
/opt/ruby/bin/gem install chef --no-ri --no-rdoc
/opt/ruby/bin/gem install puppet --no-ri --no-rdoc

#Installing vagrant keys
mkdir /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

#Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
sh /mnt/VBoxLinuxAdditions.run || true # This will fail if X11 is not installed (it is currently not installed)
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Remove items used for building, since they aren't needed anymore
apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove

# Not sure if this is needed for hardy too
# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp3/*

# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -r /dev/.udev/
rm /etc/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

mv /usr/bin/sudo /usr/bin/sudo-real
tee /usr/bin/sudo <<'LITERAL'
while 
  case "$@" in 
    '') false 
      ;; 
  esac 
do 
  case "$1" in 
    -E) 
        shift ; shift 
      ;; 
     *) arglist="$arglist $1" 
        shift 
      ;; 
  esac 
done 

/usr/bin/sudo-real $arglist || exit $?
LITERAL

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M || rm -f /EMPTY || true

echo "POSTINSTALL COMPLETE"

exit
