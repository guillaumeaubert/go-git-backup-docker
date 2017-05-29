#!/bin/bash

/app/daily-backup.sh 2>&1 | tee -a /data/go-git-backup.log | mail -s "Git Backups | `date +'%Y-%m-%d %r %Z'`" root
