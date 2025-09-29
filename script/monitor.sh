#!/bin/bash

LOGFILE="../logs/monitor.log"

echo "---- System Health Check: $(date) ----" >> $LOGFILE
echo "CPU Load: $(uptime)" >> $LOGFILE
echo "Memory Usage:" >> $LOGFILE
free -h >> $LOGFILE
echo "Disk Usage:" >> $LOGFILE
df -h >> $LOGFILE
echo "---------------------------" >> $LOGFILE
