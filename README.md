# SSH Docker jumpbox

Forked from https://github.com/monsoft/ssh-docker-jumpbox, who based on
https://github.com/warden/docker-jumpbox.

This version uses environment variables for a single user and public key, and
prevents the user from logging in.  This can only be used for creating reverse
tunnels (ssh's `-R` option) without an interactive session (ssh's `-N` option).


## Building the image

To build the docker image locally, clone this repo and run the build command:

```sh
cd ssh-docker-jumpbox
docker build --rm -t ssh-jumpbox .
```

Then refer to the image as `ssh-jumpbox` instead of `joeyparrish/ssh-jumpbox`.


## Starting ssh-jumpbox

Copy your desired _public_ key and username into docker environment variables.
In this example, we expose port 22 in the container as port 1022 in the host.

```sh
docker run \
    -d \
    -e JUMP_USER="foo" \
    -e JUMP_PUBLIC_KEY="ssh-rsa G5k8URQHMcu1DU1A58WhE6yy foo@bar" \
    -p 1022:22 joeyparrish/ssh-jumpbox
```
