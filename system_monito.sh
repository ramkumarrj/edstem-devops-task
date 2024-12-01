#!/bin/bash

# Configuration
SERVER_LOG_FILE="/var/log/syslog"      
THRESHOLD_MEMORY=80                    
THRESHOLD_CPU=80                       
#SMTP           
SMTP_SERVER="smtp.devops.com"        
SMTP_PORT=587                        
SMTP_USER="server@devops.com"      
SMTP_PASS="your_password"          
TO_EMAIL="rrkumar1002@devops.com"  

# Function to send email notifications
send_email() {
    SUBJECT="Error Detected in Server Logs"
    BODY="An error pattern was detected in the server logs. Please check the logs for more details."
    
    echo -e "Subject:$SUBJECT\n\n$BODY" | msmtp --host=$SMTP_SERVER --port=$SMTP_PORT --auth=on --user=$SMTP_USER --passwordeval="echo $SMTP_PASS" $TO_EMAIL
}

# Function to check server logs for specific error patterns
check_server_logs() {
    echo "Checking server logs for errors..."
    if grep -q "ERROR" "$SERVER_LOG_FILE"; then
        echo "Alert: Found error pattern 'ERROR' in server logs!"
        send_email  # Send email notification
    else
        echo "No errors found in server logs."
    fi
}

# Function to monitor resource usage
monitor_resources() {
    echo "Monitoring resource usage..."
    
    # Check memory usage
    MEMORY_USAGE=$(free | awk '/Mem/{printf("%.0f"), $3/$2*100}')
    echo "Memory Usage: $MEMORY_USAGE%"
    if [ "$MEMORY_USAGE" -gt "$THRESHOLD_MEMORY" ]; then
        echo "Alert: Memory usage exceeded threshold!"
        send_email  # Send email notification for high memory usage
    fi

    # Check CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    echo "CPU Usage: $CPU_USAGE%"
    if [ "$(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc)" -eq 1 ]; then
        echo "Alert: CPU usage exceeded threshold!"
        send_email  # Send email notification for high CPU usage
    fi
}

# Main execution loop
while true; do
    check_server_logs
    monitor_resources
    
    sleep 60  # Wait for 60 seconds before checking again
done
