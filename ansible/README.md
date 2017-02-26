# Getting Started with Ansible

In ansible we use one or many "control machines" to provision "managed nodes". This guide assumes you are using your laptop as a control machine on a newly created box on eclips.is with a root user and a known IP address.

# 1. Enabling ssh access

# On managed node:

* ssh into box as root (no password required if using eclips.is)
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
