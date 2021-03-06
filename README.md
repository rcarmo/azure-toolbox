# azure-toolbox

[![Docker Stars](https://img.shields.io/docker/stars/rcarmo/azure-toolbox.svg)](https://hub.docker.com/r/rcarmo/azure-toolbox)
[![Docker Pulls](https://img.shields.io/docker/pulls/rcarmo/azure-toolbox.svg)](https://hub.docker.com/r/rcarmo/azure-toolbox)

[hub]: https://hub.docker.com/r/rcarmo/azure-toolbox

    docker run -d -p 2211:22 -p 5901:5901 rcarmo/azure-toolbox


![screenshot](screenshot.jpg)

# NOTE: THIS IS IN HIATUS DUE TO THE INTRODUCTION OF AZURE CLOUD SHELL

Since the Azure Portal now provides a built-in HTML5 terminal with a working CLI and the option to run other tools like Terraform, this image is not going to be actively maintained moving forward, and is kept as a reference for further builds.

# About

A standalone development environment to work on [Azure][a] solutions, containing:

* An Ubuntu 16.04 LTS (Xenial) userland
* A simple X11 desktop (using the Infinality font rendering engine) that you can access over VNC
* Firefox and Google Chrome
* [Azure CLI][az] 2.0
* [Visual Studio Code][vc]
* Go 1.8
* The Docker CLI tools

In addition, with the `:java` tag, you get:

* Java 8 
* [Leiningen][lein] 

And on top of that, with the (experimental) `:ml` tag, you get a full-blown deep learning environment:

* Continuum Anaconda (Python 3.6)
* CNTK (built for CPU only)
* Tensorflow (built for CPU only)
* Apache MXNet

## Logging In

Login via SSH to port 2211 as `user`, password `changeme`. Once inside, `remote.sh` will launch the VNC server with a set of predefined resolutions (use `xrandr -s <resolution>` to resize the desktop - some VNC clients may need to reconnect, but TigerVNC seems to work fine in Windows, and so does the macOS VNC client)

## Quickstart (NO AUTHENTICATION!)

    docker run -d -p 5901:5901 rcarmo/azure-toolbox /quickstart.sh noauth

No need to use SSH, no VNC authentication. Great for trying it out -- but a bad idea if you expose Docker ports outside your machine.

If you're using a Mac, then don't use `noauth` and type `changeme` as a VNC password (the built-in VNC client rightfully dislikes null authentication options).

## Typical Session (via SSH)

    > docker run -d -p 2211:22 rcarmo/azure-toolbox
    93b7f70b971468095ba737b1d942131362c9bd7281905f5e8924fd8ddf36300d 
    > ssh -p 2211 -L 5901:localhost:5901 user@localhost
    The authenticity of host '[localhost]:2211 ([127.0.0.1]:2211)' can't be established.
    ECDSA key fingerprint is SHA256:Kizn3NWB7LNUjG6BejExMA5f9ZC+Ch4BkooADRgXKZ8.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '[localhost]:2211' (ECDSA) to the list of known hosts.
    user@localhost's password:
    $ sh renote.sh
    You will require a password to access your desktops.
    
    Password:
    Verify:
    xauth:  file /home/user/.Xauthority does not exist
    
    New '93b7f70b9714:1 (user)' desktop is 93b7f70b9714:1
    
    Starting applications specified in /home/user/.vnc/xstartup
    Log file is /home/user/.vnc/93b7f70b9714:1.log
    $
    # you can now VNC to localhost:5901

## Preserving Your Work

Just mount a data volume and work inside it. For instance, in Windows:

    docker run -d -p 5901:5901 -v c:/Users/billg/Development:/home/user/Development rcarmo/azure-toolbox /quickstart.sh noauth

Preserving browser and editor settings is also doable. Just mount another volume as `/home/user/.config` and you should be set (it's probably best to copy the existing settings across first).

For instance, this is what I do to have the toolbox access my local Docker daemon, my local SSH keys and my development folder:

    IMAGE=toolbox
    #IMAGE=rcarmo/azure-toolbox:java
    docker run -d \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v c:/Users/billg/_ssh:/home/user/.ssh \
        -v c:/Users/billg/OneDrive/Development:/home/user/Development \
        -p 5901:5901 $IMAGE /quickstart.sh noauth

[Visual Studio Code][vc] stores its settings in `~/.vscode`, so you can also mount that onto a host path (mind you, sharing configuration files with your host is not necessarily a good idea).

## Security Considerations

Please note that *this container exposes port 5901*. I ordinarily use VNC exclusively over SSH, but Windows users may not have SSH installed or have trouble setting up the tunnel, so I decided to `EXPOSE` the port. Docker for Windows seems to only bind it locally, but your mileage may vary.

Also, the `quickstart.sh` script should not be considered a best practice -- if you're going to leave this running someplace, best do it properly.

If you don't pass `noauth` to `quickstart.sh` the VNC server will prompt for a password (which is `changeme` too), but that's hardly secure in practice - so if you run this container on a machine exposed to the Internet, _don't_ publish port 5901.

## Base Container

This is built upon [desktop-chrome][cd], a separate image I use as base for building similar development toolboxes. You'll find the original `EXPOSE` declaration, SSH setup, user profile skeleton and `quickstart.sh` source there.

## Changelog

* 2017-10-18: General refresh, moved to OpenJDK 9
* 2017-08-17: General refresh
* 2017-08-14: VS Code 1.15
* 2017-08-04: General refresh
* 2017-07-12: VS Code 1.14
* 2017-07-09: Anaconda 4.4.0 (Python 3.6), Apache MXNet
* 2017-06-09: VS Code 1.13, CNTK 2.0, Chrome 59, general refresh
* 2017-05-01: Firefox 53, VS Code 1.11.2, Tensorflow 1.1.0, CNTK 2.0rc2, general refresh
* 2017-04-07: Go 1.8.1, VS Code 1.11.1, Keras, general refresh
* 2017-03-26: New refresh (from new base image with updated VNC server), CNTK support
* 2017-03-09: Refreshed browsers and VSCode
* 2017-03-03: Added [Leiningen][lein], Go 1.8 and the Docker CLI tools 
* 2017-02-28: NodeJS and the old [azure-xplat-cli][xcli] are no longer included, since the [Azure CLI 2.0][az] has been released. Upgraded to Chrome 56, Firefox 51.

[a]: http://azure.microsoft.com
[xcli]: https://github.com/azure/azure-xplat-cli
[az]: https://github.com/azure/azure-xplat-cli
[vc]: http://code.visualstudio.com
[cd]: https://github.com/rcarmo/docker-templates/tree/master/desktop-chrome
[lein]: https://leiningen.org/
