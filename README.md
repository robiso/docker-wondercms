# docker-wondercms
Docker image for WonderCMS, a flat file CMS (https://www.wondercms.com/).

This image sets up a development environment and relies on Debian Linux, Apache 2 and PHP7.

## How to use this image

This will start a Wonder CMS instance listening on port 80:

```
git clone https://github.com/robiso/wondercms.git
docker build -t robiso/wondercms .
# create a volume for persistence
docker volume create wondercms
# launch the container on port 8080
docker run --name wondercms -d -p 8080:80 -v wondercms:/var/www/html robiso/wondercms
```
