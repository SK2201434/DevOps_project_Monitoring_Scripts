#!/bin/bash

# Cron Job Setup Script for Server Monitoring

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONITOR_SCRIPT="$SCRIPT_DIR/server-health-monitor.sh"

echo "╔════════════════════════════════════════╗"
echo "║   Automated Monitoring Setup          ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check if monitoring script exists
if [ ! -f "$MONITOR_SCRIPT" ]; then
    echo "❌ Error: Monitoring script not found at $MONITOR_SCRIPT"
    exit 1
fi

echo "📍 Monitoring script location: $MONITOR_SCRIPT"
echo ""

# Display cron job options
echo "Choose monitoring frequency:"
echo ""
echo "1) Every hour (recommended for production)"
echo "2) Every 30 minutes (high-frequency monitoring)"
echo "3) Every 6 hours (low-frequency monitoring)"
echo "4) Daily at 9 AM (once per day)"
echo "5) Custom schedule"
echo "6) View current cron jobs"
echo "7) Remove monitoring cron jobs"
echo ""

read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        CRON_SCHEDULE="0 * * * *"
        DESCRIPTION="every hour"
        ;;
    2)
        CRON_SCHEDULE="*/30 * * * *"
        DESCRIPTION="every 30 minutes"
        ;;
    3)
        CRON_SCHEDULE="0 */6 * * *"
        DESCRIPTION="every 6 hours"
        ;;
    4)
        CRON_SCHEDULE="0 9 * * *"
        DESCRIPTION="daily at 9 AM"
        ;;
    5)
        echo ""
        echo "Cron format: minute hour day month weekday"
        echo "Example: 0 */2 * * * (every 2 hours)"
        read -p "Enter custom cron schedule: " CRON_SCHEDULE
        DESCRIPTION="custom schedule"
        ;;
    6)
        echo ""
        echo "Current cron jobs:"
        crontab -l 2>/dev/null | grep -v "^#" || echo "No cron jobs found"
        exit 0
        ;;
    7)
        echo ""
        echo "Removing monitoring cron jobs..."
        crontab -l 2>/dev/null | grep -v "server-health-monitor.sh" | crontab -
        echo "✅ Monitoring cron jobs removed"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

# Add cron job
CRON_JOB="$CRON_SCHEDULE $MONITOR_SCRIPT >> $SCRIPT_DIR/logs/cron-output.log 2>&1"

# Backup existing crontab
crontab -l 2>/dev/null > /tmp/crontab_backup_$$

# Add new job if it doesn't exist
if crontab -l 2>/dev/null | grep -q "$MONITOR_SCRIPT"; then
    echo ""
    echo "⚠️  Monitoring job already exists in crontab"
    read -p "Do you want to replace it? (y/n): " replace
    if [ "$replace" = "y" ]; then
        crontab -l 2>/dev/null | grep -v "$MONITOR_SCRIPT" | crontab -
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "✅ Cron job updated"
    else
        echo "❌ Setup cancelled"
        exit 0
    fi
else
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✅ Cron job added successfully"
fi

echo ""
echo "╔════════════════════════════════════════╗"
echo "║   Automated Monitoring Configured     ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Schedule: $DESCRIPTION"
echo "Command: $MONITOR_SCRIPT"
echo "Logs: $SCRIPT_DIR/logs/cron-output.log"
echo ""
echo "📋 View all cron jobs: crontab -l"
echo "🗑️  Remove cron jobs: ./setup-cron.sh (choose option 7)"
echo "📊 Check status anytime: ./quick-status.sh"
echo ""
echo "✅ Monitoring will run automatically $DESCRIPTION"
