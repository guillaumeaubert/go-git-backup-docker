Docker Image for go-git-backup
==============================


Code Status
-----------

[![Docker Build Status](https://img.shields.io/docker/build/aubertg/go-git-backup-docker.svg)](https://hub.docker.com/r/aubertg/go-git-backup-docker/builds/)
[![Docker Pulls](https://img.shields.io/docker/pulls/aubertg/go-git-backup-docker.svg)](https://hub.docker.com/r/aubertg/go-git-backup-docker/)


Overview
--------

A Docker image that runs go-git-backup via cron for regular backups of GitHub and BitBucket accounts.

	docker pull aubertg/go-git-backup-docker
	docker run \
		-v /host/storage/path/:/data \
		-v /my/host/.gitbackuprc.yml:/etc/gitbackuprc.yml \
		-v /my/host/ssmtp.conf:/etc/ssmtp/ssmtp.conf \
		-t \
		-d \
		--name=GitBackups \
		-e BACKUPS_UID=$(id -u myuser) \
		-e BACKUPS_GID=$(id -g myuser) \
		--memory="512m" \
		aubertg/go-git-backup-docker


Volumes
-------

The container requires the following volumes to be attached in order to work
properly:

* **`/data`**  
	Where the git clones will be stored.

* **`/etc/gitbackuprc.yml`**  
	A go-git-backup configuration file. See [go-git-backup
	setup](https://github.com/guillaumeaubert/go-git-backup#setup) for a
	description of the format of this file. Make sure that the `backup_directory`
	part of this file is set to `/data` so that backups are correctly stored on
	the host.

	Example:
	```
	backup_directory: /data
	targets:
	  - name: github-mygithubusername
	    source: github
	    type: users
	    entity: mygithubusername
	    token: mysecrettoken
	```

* **`/etc/ssmtp/ssmtp.conf`**  
	An ssmtp config file to send emails reports from the Docker container.

	Example for Gmail:
	```
	# Settings for Gmail SMTP service.
	mailhub=smtp.gmail.com:587
	hostname=smtp.gmail.com:587
	UseSTARTTLS=YES
	FromLineOverride=YES

	# Gmail account.
	root=mygmailaddress@gmail.com
	AuthUser=mygmailaddress@gmail.com
	AuthPass=mypassword
	```


Environment Variables
---------------------

The container is configurable through the following environment variables:

* **`BACKUPS_UID`** *(optional)*  
  A numeric uid in the host that should own created files.

* **`BACKUPS_GID`** *(optional)*  
  A numeric gid in the host that should own created files.

* **`BACKUPS_TZ`** *(optional, defaults to America/Los_Angeles)*  
  Timezone for the backup processes.


Copyright
---------

Copyright (C) 2017 Guillaume Aubert


License
-------

This software is released under the MIT license. See the LICENSE file for
details.


Disclaimer
----------

I am providing code in this repository to you under an open source license.
Because this is my personal repository, the license you receive to my code is
from me and not from my employer (Facebook).
