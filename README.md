# OpenGenera 2.0 Virtual Machine Environment

## About

Runs "opengenera2" on Ubuntu 7.10 inside virtualbox using vagrant, veewee, and chef. An old version of Ubuntu is required due to a "feature" of X11 being fixed in newer versions.

This *does not include* genera. It requires that you supply a bzip2 tar archive named opengenera.tar.bz2 with the (abridged) files listed in notes/opengenera2.tar.list.

## Get Ready
To launch a virtualbox VM running genera:

  * Install the latest [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  * Install the latest [Vagrant](https://www.vagrantup.com/downloads.html)
  * Install veewee: ```sudo gem install veewee```

  * ```make && vagrant up```

This will create an ubuntu-7.10-server-amd64 drive image that is staged for use with vagrant. Practically this means sizing a new disk image, installing the OS with specific settings, installing some base ruby packages, creating a vagrant user, etc (http://vagrantup.com/v1/docs/base_boxes.html). Vagrant will then launch this image in virtual box and set up port forwarding (2222 -> vm 22, 5902 -> vm 5901). On launch, chef-solo is used to evaluate the opengenera cookbook, which jumps through some hoops to set up opengenera (see notes/*), and run it inside a VNC session.

## Get Set
After the server is running, you can use opengenera by opening:

    vnc://localhost:5902 password "genera"

Open Genera setup:

    "login Lisp-Machine"
    "define site <Something Fancy>"
    Left click value of "Namespace Server Name". Change to "genera"
    Left click value of "Unix Host Name". Change to "genera-host"
    Left click "<end> uses these values"
    Type return to login anonymously
    ":reset network"
    
    ;;; "save world" ; not working, but you're in a VM that can be paused

## Go!

[Tour](TOUR.md)

# Additional Reading

http://www.textfiles.com/bitsavers/pdf/symbolics/

![splash screen](http://github.com/ynniv/opengenera/raw/master/screenshots/splash%20screen.png) 
![documentation viewer](http://github.com/ynniv/opengenera/raw/master/screenshots/documentation%20viewer.png) 
