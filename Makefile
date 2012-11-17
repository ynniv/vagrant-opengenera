# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

all: ubuntu-8.04.4-server-amd64 opengenera2.tar.bz2

clean:
	vagrant destroy
	rm -f ubuntu-8.04.4-server-amd64.box

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
ubuntu-8.04.4-server-amd64.box: veewee
	echo "### need to build ubuntu-8.04.4-server-amd64.box"
	vagrant basebox define -f ubuntu-8.04.4-server-amd64 ubuntu-8.04.4-server-amd64;
	vagrant basebox build  -f ubuntu-8.04.4-server-amd64;
	vagrant basebox validate ubuntu-8.04.4-server-amd64;
	vagrant basebox export   ubuntu-8.04.4-server-amd64;

# test that the base box is installed. make it if not.
ubuntu-8.04.4-server-amd64: vagrant
	if test -z "$$(vagrant box list | grep -w ubuntu-8.04.4-server-amd64)" ; then \
	  make ubuntu-8.04.4-server-amd64.box; \
	  vagrant box add ubuntu-8.04.4-server-amd64 ubuntu-8.04.4-server-amd64.box; \
	fi
