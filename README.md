# OpenGenera

Runs "opengenera2" inside virtualbox using vagrant and chef.

This *does not include* genera. It requires that you supply a bzip2 tar archive named opengenera.tar.bz2 with the (abridged) files listed in notes/opengenera2.tar.list.

To launch a virtualbox VM running genera, run:

```sh
$ vagrant up
```

Vagrant will then launch this image in virtual box and set up port forwarding (2222 -> vm 22, 5902 -> vm 5901).
On launch, chef-solo is used to evaluate the opengenera cookbook, which jumps through some hoops to set up opengenera (see notes/), and run it inside a VNC session.

After the server is running, you can use opengenera by opening:

```
vnc://localhost:5902 password "genera"
```

Open Genera setup:

```
"login Lisp-Machine"
"define site <sitename>"
Left click value of "Namespace Server Name". Change to "genera"
Left click value of "Unix Host Name". Change to "genera-host"
Left click "<end> uses these values"
Type return to login anonymously
":reset network"

;;; "save world" ; not working :(
```

Enjoy!

## Screenshoots

![splash screen](screenshots/splash%20screen.png)

![documentation viewer](screenshots/documentation%20viewer.png)

## Links
* http://www.textfiles.com/bitsavers/pdf/symbolics/
