#!/bin/bash

LOG_FILE="../logs/cron.log"

# Add a new cron job
add_cron_job() {
    SERVICE_DIR=$1
    echo "Adding a cron job to renew SSL certificates daily..."

    CRON_JOB="0 3 * * * docker-compose -f $SERVICE_DIR/docker-compose.yml exec shared-proxy-letsencrypt-companion certbot renew >> $LOG_FILE 2>&1"
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

    echo "Cron job added. It will run daily at 3 AM."
    echo "Logs will be saved in $LOG_FILE."
}

# Main entry point
main() {
    SERVICE_DIR=$1
    add_cron_job "$SERVICE_DIR"
}

main "$1"
