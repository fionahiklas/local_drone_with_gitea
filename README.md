## Overview 

Setup for running [gitea](https://docs.gitea.io) and Drone locally for testing and development purposes

Currently this is on a Mac but should be transferrable to anything running Docker.


## Setup

### Forward Proxy

Needed so that a browser can successfully connect to the various containers on 
the internal network and such that the same host names can be used internally 
(to Docker) and externally.

The problem is that gitea and Drone will be referring to each others hosts 
(for OAuth and webhooks0, this should work fine for any communication within
Docker since it's internal DNS resolution should work.  

However, for an external browser connection ports need to be exposed and these 
would likely sit on localhost.  To get the same DNS naming would require
hacking the `/etc/hosts` file which is messy.

The forward proxy allows a browser to connect and have all resolution and 
connections made internal to Docker networking.

Create the Docker image using the following command

```
cd forwardproxy
docker build -t forwardproxy:latest .
```

When the Gitea docker containers (which includes the proxy) have been brought 
up you can test using a command like this

```
curl -v -x http://localhost:7777 http://gitea:3000
```


### Gitea

Following [Docker install](https://docs.gitea.io/en-us/install-with-docker/) 
instructions for Gitea.

Run the following command to start gitea and the forward proxy.

```
docker-compose up -d -f docker-compose-gitea.yml
```

Check status with `docker-compose ps` or `docker ps`

In a browser, set the HTTP proxy to `localhost:7777`

Visit gitea using the URL `http://gitea:3000`

At this point (for a new installation) clicking on `Register` or `signin` redirects to `http://gitea:3000/install`

Leave all the settings apart from the following:

* `Gitea base URL` - since the given `docker-compose.yml` setup/ports, change this to `http://gitea:3000/`
* `Administrator account` - created a user called `giteaadmin` and password `password`

Press the install button and it will drop you into the admin user after installation, sign out from this.

Created a new account (Using "Register" button) with the following details 

* Username `sandbox`
* Email `sandbox@mailinator.com`
* Password: `Password12345!`


### Drone

Following the [Gitea install instructions](https://docs.drone.io/installation/providers/gitea/)

As the `sandbox` user go to Settings -> Applications and create a new 
application with the following information

* `Application name`: drone
* `Redirect URI`: http://drone/login



## Notes

### gitea/etc directory

This was created due to an error from Docker on MacOS when starting the gitea container

```
ERROR: for gitea_server_1  Cannot start service server: b'Mounts denied: \r\nThe paths /etc/timezone and /etc/localtime\r\nare not shared from OS X and are not known to Docker.\r\nYou can configure shared paths from Docker -> Preferences... -> File Sharing.\r\nSee https://docs.docker.com/docker-for-mac/osxfs/#namespaces for more info.\r\n.'

ERROR: for server  Cannot start service server: b'Mounts denied: \r\nThe paths /etc/timezone and /etc/localtime\r\nare not shared from OS X and are not known to Docker.\r\nYou can configure shared paths from Docker -> Preferences... -> File Sharing.\r\nSee https://docs.docker.com/docker-for-mac/osxfs/#namespaces for more info.\r\n.'
ERROR: Encountered errors while bringing up the project.
```

Rather that map /etc/localtime from the Mac to Docker (running Linux in a hypervisor) it seems easier to have a local etc
directory.  Also MacOS does not seem to include a `/etc/timezone` file either.


## References 

### Gitea

* [Docs](https://docs.gitea.io/en-us/)


### Drone

* [Gitea install instructions](https://docs.drone.io/installation/providers/gitea/)


### Docker

* [Timezone with Docker and host](https://medium.com/developer-space/be-careful-while-playing-docker-about-timezone-configuration-e7a2217e9b76)
* [/etc/localtime /etc/timezone mounts on MacOS with Docker](https://github.com/docker/for-mac/issues/2396)
* [Using nginx as a proxy](https://www.thepolyglotdeveloper.com/2017/03/nginx-reverse-proxy-containerized-docker-applications/)


### Linux/UNIX

* [Dump localtime](https://unix.stackexchange.com/questions/85925/how-can-i-examine-the-contents-of-etc-localtime)
* [Difference betweemn timezone and localtime](https://unix.stackexchange.com/questions/384971/whats-the-difference-between-localtime-and-timezone-files)
* [Linux/UNIX timezone files](https://linux-audit.com/configure-the-time-zone-tz-on-linux-systems/)
* [nginx forward proxy](https://github.com/reiz/nginx_proxy/blob/master/nginx_blacklist.conf)
* [using nginx as forward proxy](https://stackoverflow.com/questions/46060028/how-to-use-nginx-as-forward-proxy-for-any-requested-location)
