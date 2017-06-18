FROM golang:alpine
MAINTAINER Guillaume Aubert "aubertg@cpan.org"

ENV FIRST_RUN_FLAG="/app/.first_run" \
	GOPATH="/go" \
	PATH="/go/bin:$PATH" \
	GOPKGDIR="/go/src/github.com/guillaumeaubert/go-git-backup"

VOLUME /data

# Set up environment.
RUN apk add --update \
		git \
		bash \
		shadow \
		ssmtp \
		tzdata \
		mailx \
	&& rm -rf /var/cache/apk/*
RUN addgroup abc \
	&& adduser -s /bin/bash -G abc -H -D abc

# Add Golang prerequisites.
RUN go get gopkg.in/yaml.v2

# Clone application source repository.
RUN git clone https://github.com/guillaumeaubert/go-git-backup.git $GOPKGDIR

# Schedule regular checks.
RUN mkdir /app
COPY heartbeat.sh /app/
COPY daily-backup.sh /app/
COPY daily-backup-wrapper.sh /app/
COPY crontab /var/spool/cron/crontabs/root

# Launch app.
COPY start.sh /app/
RUN touch $FIRST_RUN_FLAG
WORKDIR /app
CMD ["/app/start.sh"]
