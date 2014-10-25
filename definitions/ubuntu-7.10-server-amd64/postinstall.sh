#http://adrianbravo.tumblr.com/post/644860401

set -e

date > /etc/vagrnat_box_build_time

# ideally this would be excluded in the preseed
sed -i.bak 's/^.*cdrom.*$//g' /etc/apt/sources.list
apt-get -y update

cat /etc/apt/sources.list
apt-cache search linux-headers
apt-cache search zlib1g-dev

# Install NIS for Genera-to-Linux authentication

# The first step is to migrate passwords to crypt (from MD5)
# and away from shadow passwords/groups (Genera can't support them)

sed -i -e 's/obscure md5/obscure/' /etc/pam.d/common-password
pwunconv
grpunconv

# We need to re-set 'root' and 'vagrant' passwords
# to 'vagrant', since we changed from md5 to crypt

sed -r -i -e 's/^root:[^\:]+:/root:NmtEjLX7mwMRw:/' /etc/passwd
sed -r -i -e 's/^vagrant:[^\:]+:/vagrant:LropGSyjPBX2s:/' /etc/passwd

# Temporarily set our host name to 'genera-host' so ypinit
# will pick it up correctly
hostname genera-host

# Now we make sure NIS doesn't start immediately after install.
# This is to prevent an annoying 2-minute long hang.
cat > /usr/sbin/policy-rc.d << EOF
#!/bin/sh
echo "All runlevel operations denied by policy" >&2
exit 101
EOF
chmod +x /usr/sbin/policy-rc.d

# Now set the NIS domainname
echo 'genera' > /etc/defaultdomain

# ... and install non-interactively
DEBIAN_FRONTEND=noninteractive apt-get install -q -y nis

# make sure we're the master NIS server
sed -i -e 's/NISSERVER=false/NISSERVER=master/' /etc/default/nis
sed -i -e 's/NISCLIENT=true/NISCLIENT=false/' /etc/default/nis

# This will look like it failed with some errors, but it's successful,
# don't worry.
cd /var/yp
make

# Now we can get rid of that policy file...
rm -f /usr/sbin/policy-rc.d

# OK, now we can authenticate against the Linux host in Genera when we
# next boot!

#Updating the box
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev nfs-common
apt-get clean

#Setting up sudo
cp /etc/sudoers /etc/sudoers.orig
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

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
sh /mnt/VBoxLinuxAdditions.run || true
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

# Make sure we can run sudo that doesn't support the '-E' flag used by
# Vagrant
mv /usr/bin/sudo /usr/bin/sudo-real
(cat <<'LITERAL' > /usr/bin/sudo
#!/bin/sh
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
) && chmod a+x /usr/bin/sudo

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M || rm -f /EMPTY || true

exit
