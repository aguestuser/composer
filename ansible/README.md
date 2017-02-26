# Getting Started with Ansible

In ansible we use one or many "control machines" to provision "managed nodes". This guide assumes you are using your laptop as a control machine on a newly created box on eclips.is with a root user and a known IP address.

# 0. Creating managed node

* login to eclips.is with following info:

```
url: https://portal.eclips.is
username: whereat.admin@riseup.net
password: <REDACTED>
```
* click "cloud managment"
* click "add instance"
* make a debian jessie box
* suggested specs: 4gb ram, 2 cores, 40gb HD

* **TODO:** accomplish the above via the [eclips.is api](https://portal.eclips.is/portal/cloud/ApiDoc#/default)

# 1. Enabling ssh access

# On managed node:

* ssh into box created in step 0 as root (or use the console that pops up after creating box)
* create a user for yourself with:

``` shell
adduser <yourname>
usermod -aG sudo <yourname>
```

* give your user password-less ssh permissions by running:

``` shell
visudo
```

* then edit the line that looks like this:

``` shell
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL)
```

* to look like this:

``` shell
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) NOPASSWD:ALL
```

## On Control Machine:

* If you do not already have an ssh key you want to use to access the managed nodes, create one with:

``` shell
$ ssh-keygen -t ed25519 -o -a 100 -f ~/.ssh/id_<name_of_key>
```

* If you do not already have a way of storing your ssh key password in a keyring to avoid re-entering its password every time you want to use it, you can use this:

``` shell
$ ssh-agent bash
$ ssh-add ~/.ssh/id_<name_of_key>
```
* (Optionally) Add the control machine to your ssh config file
* Assuming:
  * managed node hostname: `crisisbox-councourse-00`
  * managed node ip address: `1.1.1.1`
  * username: `alice`
  * keyname:  `id_crisisbox_concourse_alice`

* Write the following to `~/.ssh/config`:

``` shell
Host crisisbox-concourse-00
    HostName 1.1.1.1
    User alice
    IdentityFile ~/.ssh/id_crisisbox_concourse_alice
    IdentitiesOnly yes
```

* Test that you can ssh into the box with either:

(if you added lines to `~/.ssh/config`):

``` shell
$ ssh crisisbox-concourse-00
```

(if you did not add lines to `~/.ssh/config`):

``` shell
$ ssh alice@1.1.1.1
```


# 2. Installing ansible on control machine

## For non-Debian machines
* consult [install guide](http://docs.ansible.com/ansible/intro_installation.html)
* for debian:

## On Debian

* add this line to `etc/apt/sources.list` to add ansible packages to dpkg:

```conf
deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main
```

* run these commands to install:

``` shell
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
$ sudo apt-get update
$ sudo apt-get install ansible
```

# 3. Use Ansible to connect control machine to managed node(s)

* add a list of managed nodes to `/etc/ansible/hosts`
* to add the hosts for crisisbox, start in the root directory of this repo and run:

``` shell
$ sudo cp ansible/hosts /etc/ansible/hosts
```

* smoke test that you can connect your control machine to all managed nodes with:

``` shell
$ ansible all -m ping
```

* you should get a response back that looks something like:

``` shell
1.1.1.1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

```

# 4. Provision a box to run concourse (TODO)

The following steps are required to manually provision a box to run [concourse.ci](https://concourse.ci/introduction.html). Let's write a [playbook](http://docs.ansible.com/ansible/playbooks_intro.html) to do it with ansible instead!

* figure out which version of the linux kernel you're running:

``` shell
uname -a
```

* reinstall linux kernel to enable `iptables` modules necessary to run docker:

(assuming the above returned `linux-image-3.16.0-4`):

``` shell
apt install --reinstall linux-image-3.16.0-4
```

* to install docker (as per [these instructions](https://docs.docker.com/engine/installation/linux/debian/#/install-docker)):

``` shell
sudo su

apt install -y --no-install-recommends \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common

curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       debian-$(lsb_release -cs) \
       main"
apt update
apt -y install docker-engine
service docker start
docker run hello-world
```

* to provision concourse (as per [these instructions](http://concourse.ci/docker-repository.html)):

* put a `docker-compose` file like the one in `build/concourse/docker-compose.yml` on the file system of the managed node you want to provision with councourse

* generate ssh keys with:

``` shell
mkdir -p keys/web keys/worker
ssh-keygen -t rsa -f ./keys/web/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/web/session_signing_key -N ''
ssh-keygen -t rsa -f ./keys/worker/worker_key -N ''
cp ./keys/worker/worker_key.pub ./keys/web/authorized_worker_keys
cp ./keys/web/tsa_host_key.pub ./keys/worker
```
* configure an ip address at which you want your `web` node to be reachable
* assuming you want that address to be `192.168.99.100`, run:

``` shell
export CONCOURSE_EXTERNAL_URL=http://192.168.99.100:8080
```

* spin up concourse with:

``` shell
docker-compose up
```

* you can now log into concourse at 192.168.99.100:8080 with username `concourse` and password `changeme`

* some sample build pipeline configurations:
  * [deploy a rails app if tests pass](http://concourse.ci/flight-school.html)
  * [worker with two controllers and integration tests](http://concourse.ci/pipelines.html)
  * [tutorial with increasingly complex pipelines](https://github.com/starkandwayne/concourse-tutorial)
