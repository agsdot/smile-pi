A Vagrant setup that can be applied to 1) a Vagrant box to build a [Archlinux](https://www.archlinux.org/) instance with [SMILE software](https://gse-it.stanford.edu/research/project/smile) and 2) build scripts to run on a Raspberry Pi 3.

To do the first option, download [virtualbox](https://www.virtualbox.org/wiki/Downloads), [vagrant](https://www.vagrantup.com/downloads.html), and clone this github repo, then run a "vagrant up" and in 20 minutes you'll have a smile instance running. Just goto http://localhost:8080 .

To do the second option, first create an Raspbian Jesse Lite image on a microsd card. (PSA: once you create a good image, create a clone of that sd card using dd on a mac or linux, or [Apple Pi Baker](http://www.tweaking4all.com/software/macosx-software/macosx-apple-pi-baker/) on a mac).

Place the microsd in the raspberry pi and boot it up.

On a rpi3, login in as root (the image should have a minimal amount of packages on it; no git, no wget, no sudo, etc (no nothing, and yes that's a double negative...). However, curl is included on the image.)

`sudo passwd`

  - curl -O https://raw.githubusercontent.com/canuk/vagrant-archbox/master/bootstrap.sh
  - chmod +x bootstrap.sh
  - sh bootstrap.sh

After that is done, login as pi (the default non root user) and in the home directory run "bash ~/rpi3_install.sh". From there you will have the option to install various applications (smile, kiwix, kalite, the portal page). Be sure to include the basic_setup.sh file, it is required by all the other application scripts.

Enjoy

P.s. Point of note, Archlinux comes in several different flavors: x86, x86_64, ARM.  The Vagrant box builds the files off of a linux image that is x86_64 and the rpi3 is an ARM box. The majority of packages and downloads work just fine, some require some customization to work on the ARM build.

P.p.s.For more troubleshooting goodness/goodies on the rpi3, you can install the following: xfce4 (follow this [tutorial](https://www.zybuluo.com/yangxuan/note/344907), and install these packages  xfce4 xorg-server xf86-video-fbdev xorg-xrefresh), and [x2go](https://wiki.archlinux.org/index.php/X2Go) for remote access.
