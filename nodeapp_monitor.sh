#!/bin/bash

# Configuration
APP_LOG_FILE="/var/log/app.log"  
ERROR_PATTERN="ERROR"     
#SMTP           
SMTP_SERVER="smtp.devops.com"        
SMTP_PORT=587                        
SMTP_USER="server@devops.com"      
SMTP_PASS="your_password"          
TO_EMAIL="rrkumar1002@devops.com"  

# Function to send email notifications
send_email() {
    SUBJECT="Error Detected in Application Logs"
    BODY="An error pattern was detected in the application logs: '$ERROR_PATTERN'. Please check the logs for more details."
    
    echo -e "Subject:$SUBJECT\n\n$BODY" | msmtp --host=$SMTP_SERVER --port=$SMTP_PORT --auth=on --user=$SMTP_USER --passwordeval="echo $SMTP_PASS" $TO_EMAIL
}

# Function to check application logs for specific error patterns
check_app_logs() {
    echo "Checking application logs for errors..."
    if grep -q "$ERROR_PATTERN" "$APP_LOG_FILE"; then
        echo "Alert: Found error pattern '$ERROR_PATTERN' in application logs!"
        send_email  # Send email notification
    else
        echo "No errors found in application logs."
    fi
}

# Main execution loop
while true; do
    check_app_logs
    sleep 60  # Wait for 60 seconds before checking again
done
