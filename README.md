[![IMIO Public Cloud management tool](http://www.imio.be/logo.png)](https://github.com/IMIO/ovh.cloud)

## What

The goal of this project is to simplify management of our public cloud infrastructure (server/storage/network).

Here are some of the current helpers:

Servers:

 - List running servers in a project
 - Remove all servers in a project

SSH keys:

 - List known ssh keys in a project

## How

We use docker to create the required environment that enables communication with OVH API (https://api.ovh.com/console/).
You will need the ovh.conf to be present in this directory with the following format:

```
$ cat ~/.ovh.conf
[default]
endpoint=ovh-eu

[ovh-eu]
application_key=yourapplicationkey
application_secret=yourapplicationsecret
consumer_key=yourconsumerkey
```
