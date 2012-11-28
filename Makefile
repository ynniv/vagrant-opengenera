# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

# most of these targets are pseudotargets, and make will always think they are out of date.
# bash conditionals are liberally applied to avoid rebuilding things too often.

BASEBOX=ubuntu-7.10-server-amd64

all: opengenera-box opengenera2.tar.bz2

clean:
	vagrant destroy
	rm -f *.box snap4.tar.gz
	echo "the iso directory can be removed"

# vagrant is a tool for automating virtualbox
vagrant:
	if test -z "$$(which vagrant)" ; then \
	  echo "### need to install vagrant"; \
	  echo "try: sudo gem install vagrant"; \
	fi

# veewee might download an OS image. don't let make auto delete it, it's big!
.PRECIOUS: %.iso

$(BASEBOX).box:
	if test -z "$$(bash -c 'vagrant basebox' 2>&1 | grep 'vagrant basebox <command> ')" ; then \
	  echo "### need to install veewee"; \
	  echo "try: sudo gem install veewee"; \
	else \
	  echo "### need to build $(BASEBOX).box" \
	  vagrant basebox build --force $(BASEBOX) \
	  vagrant basebox validate $(BASEBOX) \
	  vagrant basebox export   $(BASEBOX) \
	fi

# test that the opengenera box is installed. make it if not.
opengenera-box: vagrant
	if test -z "$$(vagrant box list | grep -w opengenera)" ; then \
	  make $(BASEBOX).box; \
	  vagrant box add opengenera $(BASEBOX).box; \
	fi
