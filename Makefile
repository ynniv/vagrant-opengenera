# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

all: opengenera-ubuntu-8.04.4 opengenera2.tar.bz2

clean:
	vagrant destroy
	rm -f opengenera-ubuntu-8.04.4.box

# vagrant is a tool for automating virtualbox
vagrant:
	if test -z "$$(which vagrant)" ; then \
	  echo "### need to install vagrant"; \
	  sudo gem install vagrant; \
	fi

# veewee is a vagrant addon that stages base operating system images
veewee: vagrant
	if test -z "$$(bash -c 'vagrant basebox' 2>&1 | grep 'vagrant basebox <command> ')" ; then \
	  echo "### need to install veewee"; \
	  sudo gem install veewee; \
	fi

# veewee might download an OS image. don't let make auto delete it, it's big!
.PRECIOUS: %.iso

# this is the base box we will build on. you should just download it if possible
opengenera-ubuntu-8.04.4.box: veewee
	echo "### need to build opengenera-ubuntu-8.04.4.box"
	vagrant basebox build  --force opengenera-ubuntu-8.04.4;
	vagrant basebox validate opengenera-ubuntu-8.04.4;
	vagrant basebox export   opengenera-ubuntu-8.04.4;

# test that the base box is installed. make it if not.
opengenera-ubuntu-8.04.4: vagrant
	if test -z "$$(vagrant box list | grep -w opengenera-ubuntu-8.04.4)" ; then \
	  make opengenera-ubuntu-8.04.4.box; \
	  vagrant box add opengenera-ubuntu-8.04.4 opengenera-ubuntu-8.04.4.box; \
	fi
