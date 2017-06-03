#!/bin/bash

set -euf -o pipefail

# Define a horizontal line.
HLINE=$(printf '%*s\n' 80 '' | sed -e 's/ /─/g')

# Record start datetime.
date
echo "$HLINE"

# Update go-git-backup to the latest version of the code.
echo "Updating go-git-backup..."
cd $GOPKGDIR
git pull
echo "$HLINE"

# Back up git repositories.
go run $GOPKGDIR/gitbackup.go -config /etc/gitbackuprc.yml
echo "$HLINE"

# Add a flag with the completion time.
date +%s > /data/.last_completed
