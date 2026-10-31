# docker-wondercms

Docker image for WonderCMS, a flat file CMS (<https://www.wondercms.com/>).

This image sets up a simple single-container WonderCMS on Debian Linux, Apache 2 and PHP 8, with PHP's production settings (`php.ini-production`, display_errors off). It is meant for trying WonderCMS out and for development. For a public site put a reverse proxy with TLS in front of it, mount `data/` as a volume and keep your own backups; the image itself does no hardening beyond PHP's defaults.

This image was created and is maintained by Marco Antonio Blanco ([@mablanco](https://github.com/mablanco)) at [mablanco/docker-wondercms](https://github.com/mablanco/docker-wondercms) and published as `mablanco/wondercms` on Docker Hub. The WonderCMS project now also publishes its own image from this fork, as `ghcr.io/robiso/wondercms` (amd64 and arm64, rebuilt weekly).

## How to use this image

This will start a Wonder CMS instance listening on port 80:

```bash
~ docker run -d -p 80:80 --name wondercms mablanco/wondercms
```

If you'd like persistance, you can create a volume for that purpose:

```bash
~ docker volume create wondercms_web
~ docker run -d -p 80:80 --name wondercms -v wondercms_web:/var/www/html mablanco/wondercms
```

The WonderCMS project's image works the same way:

```bash
~ docker run -d -p 80:80 --name wondercms ghcr.io/robiso/wondercms
```

On the first visit the home page shows the generated admin password. Log in at `/loginURL` and change both the password and the login URL from the Security settings.

## Upgrading

A persistent volume keeps the files of the WonderCMS version it was created with, so switching to a newer image tag does not upgrade an existing site. Back up the volume first, then update WonderCMS from its own settings panel.

## Building the image

```bash
~ docker build -t mablanco/wondercms .
```

The WonderCMS version is set with the `WONDERCMS_VERSION` build argument, and the downloaded release is checked against `WONDERCMS_SHA256`. Update both together.

To test an unreleased WonderCMS branch, pass the branch name and an empty checksum (a branch archive changes with every commit, so it cannot be pinned):

```bash
~ docker build -t wondercms:370 --build-arg WONDERCMS_VERSION=370 --build-arg WONDERCMS_SHA256= .
```
