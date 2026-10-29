# docker-wondercms

Docker image for WonderCMS, a flat file CMS (<https://www.wondercms.com/>).

This image sets up a **development** environment and relies on Debian Linux, Apache 2 and PHP 8 (with `php.ini-development`, so errors are displayed). It should **NEVER** be used in production.

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

On the first visit the home page shows the generated admin password. Log in at `/loginURL` and change both the password and the login URL from the Security settings.

## Upgrading

A persistent volume keeps the files of the WonderCMS version it was created with, so switching to a newer image tag does not upgrade an existing site. Back up the volume first, then update WonderCMS from its own settings panel.

## Building the image

```bash
~ docker build -t mablanco/wondercms .
```

The WonderCMS version is set with the `WONDERCMS_VERSION` build argument, and the downloaded release is checked against `WONDERCMS_SHA256`. Update both together.
