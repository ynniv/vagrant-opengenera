# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

all: opengenera-ubuntu-8.04.4-base opengenera2.tar.bz2

clean:
	vagrant destroy
	rm -f opengenera-ubuntu-8.04.4-base.box

# vagrant is a tool for automating virtualbox
vagrant:
	if test -z "$$(which vagrant)" ; then \
	  echo "### need to install vagrant"; \
	  echo "try: sudo gem install vagrant"; \
	fi

# veewee is a vagrant addon that stages base operating system images
veewee: vagrant
	if test -z "$$(bash -c 'vagrant basebox' 2>&1 | grep 'vagrant basebox <command> ')" ; then \
	  echo "### need to install veewee"; \
	  echo "try: sudo gem install veewee"; \
	fi

# veewee might download an OS image. don't let make auto delete it, it's big!
.PRECIOUS: %.iso

# this is the base box we will build on. you should just download it if possible
opengenera-ubuntu-8.04.4-base.box: veewee
	echo "### need to build opengenera-ubuntu-8.04.4-base.box"
	vagrant basebox build  --force opengenera-ubuntu-8.04.4-base;
	VBoxManage controlvm opengenera-ubuntu-8.04.4-base acpipowerbutton
	VBoxManage startvm --type headless opengenera-ubuntu-8.04.4-base
	vagrant basebox validate opengenera-ubuntu-8.04.4-base;
	vagrant basebox export   opengenera-ubuntu-8.04.4-base;

# test that the base box is installed. make it if not.
opengenera-ubuntu-8.04.4-base: vagrant
	if test -z "$$(vagrant box list | grep -w opengenera-ubuntu-8.04.4-base)" ; then \
	  make opengenera-ubuntu-8.04.4-base.box; \
	  vagrant box add opengenera opengenera-ubuntu-8.04.4-base.box; \
	fi
