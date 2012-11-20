# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

BOXNAME=opengenera-ubuntu-8.04.4-base

all: $(BOXNAME) opengenera2.tar.bz2

clean:
	vagrant destroy
	rm -f $(BOXNAME).box

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

$(BOXNAME).box: veewee
	echo "### need to build $(BOXNAME).box"
	vagrant basebox build --force $(BOXNAME);
	vagrant basebox halt $(BOXNAME);
	vagrant basebox up --nogui $(BOXNAME);
	vagrant basebox validate $(BOXNAME);
	vagrant basebox export   $(BOXNAME);

# test that the base box is installed. make it if not.
$(BOXNAME): vagrant
	if test -z "$$(vagrant box list | grep -w $(BOXNAME))" ; then \
	  make $(BOXNAME).box; \
	  vagrant box add opengenera $(BOXNAME).box; \
	fi
