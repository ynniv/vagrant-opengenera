# OpenGenera 2.0 Virtual Machine Environment

## About

Runs "opengenera2" on Ubuntu 7.10 inside virtualbox using vagrant, veewee, and chef. An old version of Ubuntu is required due to a "feature" of X11 being fixed in newer versions.

This *does not include* genera. It requires that you supply a bzip2 tar archive named opengenera.tar.bz2 with the (abridged) files listed in notes/opengenera2.tar.list.

## Updating

If you are updating you probably need to destroy your previous virtual machine as well as the Ubuntu 7.10 basebox using ```make clean```.

## Get Ready
To launch a virtualbox VM running genera:

  * Install the latest [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  * Install the latest [Vagrant](https://www.vagrantup.com/downloads.html)
  * Install veewee: ```sudo gem install veewee```

  * ```make && vagrant up```

This will create an ubuntu-7.10-server-amd64 drive image that is staged for use with vagrant. Practically this means sizing a new disk image, installing the OS with specific settings, installing some base ruby packages, creating a vagrant user, etc (http://vagrantup.com/v1/docs/base_boxes.html). This takes approximately a half hour on a Core 2 Duo. Vagrant will then launch this image in virtual box and set up port forwarding (2222 -> vm 22, 5902 -> vm 5901). On launch, provision.sh jumps through some hoops to set up Open Genera (see notes/*), and run it inside a VNC session.

Building the image involves pulling files from the Internet, which introduces uncertainty. If you're having trouble completing this step, compare your build output with one possible successful output at ```notes/full-make.log```.

## Get Set
After the server is running, you can use Open Genera by opening:

    vnc://localhost:5902 password "genera"

If OG failed to launch successfully you will only see a white screen with a black status bar at the bottom. If this happens it will probably restart successfully using:

    vagrant ssh -c restart-genera

On a successful launch you will have a screen filled with pleasantly styled text. The resolution will be 1150x900, which was the native resolution of the Symbolics 3600. You should then configure the system as follows:

    "login Lisp-Machine"
    "define site <Something Fancy>"
    Left click value of "Namespace Server Name". Change to "genera"
    Left click value of "Unix Host Name". Change to "genera-host"
    Left click "<end> uses these values" (or type <End>)
    If prompted, type return to login anonymously
    ":reset network"
    
## Go!

See [TOUR](TOUR.md) for a quick guide on how to get started with the included user's guide.

## Caveats

```Save World``` will not succeed, and if it does it will not restore, and if it does then you are a lucky user! Fortunately everything is inside VirtualBox, which will let you pause, resume, and snapshot the world. While not as satisfying as using the original mechanisms, these VirtualBox capabilities are more powerful than the originals.

# Additional Reading

http://www.textfiles.com/bitsavers/pdf/symbolics/

![splash screen](https://github.com/ynniv/opengenera/raw/master/screenshots/splash%20screen.png)
![documentation viewer](https://github.com/ynniv/opengenera/raw/master/screenshots/document%20examiner.png) 
![graphical program output](https://github.com/ynniv/opengenera/raw/master/screenshots/sample%20program.png)
