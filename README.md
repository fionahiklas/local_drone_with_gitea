## Overview 

Setup for running [gitea](https://docs.gitea.io) and Drone locally for testing and development purposes

Currently this is on a Mac but should be transferrable to anything running Docker.


## Setup

### Gitea

Following [Docker install](https://docs.gitea.io/en-us/install-with-docker/) instructions.

Using the docker-compose.yaml file under ./gitea and running the following commands

```
cd gitea
docker-compose up -d
```

Check status with `docker-compose ps` or `docker ps`

Visit gitea using the URL `http://localhost:3333`

At this point (for a new installation) clicking on `Register` or `signin` redirects to `http://localhost:3333/install`

Leave all the settings apart from the following:

* `Gitea base URL` - since the given `docker-compose.yml` setup/ports, change this to `http://localhost:3333/`
* `Administrator account` - created a user called `giteaadmin` and password `password`

Press the install button and it will drop you into the admin user after installation, sign out from this.

Created a new account (Using "Register" button) with the following details 

* Username `sandbox`
* Email `sandbox@mailinator.com`
* Password: `Password12345!`



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


### Docker

* [Timezone with Docker and host](https://medium.com/developer-space/be-careful-while-playing-docker-about-timezone-configuration-e7a2217e9b76)
* [/etc/localtime /etc/timezone mounts on MacOS with Docker](https://github.com/docker/for-mac/issues/2396)


### Linux/UNIX

* [Dump localtime](https://unix.stackexchange.com/questions/85925/how-can-i-examine-the-contents-of-etc-localtime)
* [Difference betweemn timezone and localtime](https://unix.stackexchange.com/questions/384971/whats-the-difference-between-localtime-and-timezone-files)
* [Linux/UNIX timezone files](https://linux-audit.com/configure-the-time-zone-tz-on-linux-systems/)
