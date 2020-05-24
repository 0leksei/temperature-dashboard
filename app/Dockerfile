FROM alpine:3.11

RUN apk --no-cache add curl libxml2-utils

# Copy crontab and shell script
COPY poller/* /opt/poller/
COPY poller/crontab /etc/cron.d/crontab

# Give execution rights
RUN chmod 0744 /etc/cron.d/crontab
RUN chmod +x /opt/poller/poll.sh

# Apply cron job
RUN crontab /etc/cron.d/crontab

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

CMD [crond, -f, -l, 8]