FROM golang:alpine
MAINTAINER Guillaume Aubert "aubertg@cpan.org"

ENV FIRST_RUN_FLAG /app/.first_run
ENV GOPATH /go
ENV PATH /go/bin:$PATH
ENV GOPKGDIR='/go/src/github.com/guillaumeaubert/go-git-backup'

VOLUME /data
RUN mkdir /app

# Set up environment.
RUN apk add --update \
		git \
		bash \
		shadow \
		ssmtp \
		tzdata \
		mailx \
	&& rm -rf /var/cache/apk/* \
	&& addgroup abc \
  && adduser -s /bin/bash -G abc -H -D abc

# Add Golang prerequisites.
RUN go get gopkg.in/yaml.v2

# Clone application source repository.
RUN git clone https://github.com/guillaumeaubert/go-git-backup.git $GOPKGDIR

# Schedule regular checks.
COPY heartbeat.sh /app/
COPY daily-backup.sh /app/
COPY daily-backup-wrapper.sh /app/
COPY crontab /etc/cron.d/go-git-backup

# Launch app.
COPY entrypoint.sh /app/
RUN touch $FIRST_RUN_FLAG
WORKDIR /app
CMD ["/app/entrypoint.sh"]
