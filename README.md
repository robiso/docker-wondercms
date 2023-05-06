# docker-wondercms
Docker image for WonderCMS, a flat file CMS (<https://www.wondercms.com/>).

This image sets up a development environment and relies on Debian Linux, Apache 2 and PHP7.

## How to use this image

This will start a Wonder CMS instance listening on port 80:

```
$ docker run -d -p 80:80 --name wondercms robiso/wondercms
```

If you'd like persistance, you can create a volume for that purpose:

```
$ docker volume create wondercms_web
$ docker run -d -p 80:80 --name wondercms -v wondercms_web:/var/www/html robiso/wondercms
```
