#!/bin/bash

#############################################
# Server Health Monitoring System
# Author: Satish (DevOps Learning Journey)
# Purpose: Monitor server health and alert on issues
#############################################

# Color codes for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/thresholds.conf"
LOG_DIR="$SCRIPT_DIR/logs"
REPORT_DIR="$SCRIPT_DIR/reports"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_FILE="$LOG_DIR/monitor-$(date +%Y-%m-%d).log"
REPORT_FILE="$REPORT_DIR/health-report-$(date +%Y-%m-%d).txt"

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo -e "${RED}Error: Configuration file not found!${NC}"
    exit 1
fi

# Initialize log file
mkdir -p "$LOG_DIR" "$REPORT_DIR"
touch "$LOG_FILE"

# Logging function
log_message() {
    local level=$1
    shift
    local message="$@"
    echo "[$TIMESTAMP] [$level] $message" >> "$LOG_FILE"
}

# Alert function
send_alert() {
    local severity=$1
    local message=$2
    
    case $severity in
        CRITICAL)
            echo -e "${RED}🚨 CRITICAL ALERT: $message${NC}"
            ;;
        WARNING)
            echo -e "${YELLOW}⚠️  WARNING: $message${NC}"
            ;;
        INFO)
            echo -e "${GREEN}✅ INFO: $message${NC}"
            ;;
    esac
    
    log_message "$severity" "$message"
}

#############################################
# Monitoring Functions
#############################################

# Check disk usage
check_disk_usage() {
    echo -e "\n${BLUE}=== Disk Usage Check ===${NC}"
    
    # Get disk usage for root partition
    DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    echo "Current disk usage: ${DISK_USAGE}%"
    log_message "INFO" "Disk usage: ${DISK_USAGE}%"
    
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        send_alert "CRITICAL" "Disk usage is ${DISK_USAGE}% (threshold: ${DISK_THRESHOLD}%)"
        return 1
    elif [ "$DISK_USAGE" -gt $((DISK_THRESHOLD - 10)) ]; then
        send_alert "WARNING" "Disk usage is ${DISK_USAGE}% (approaching threshold)"
        return 0
    else
        send_alert "INFO" "Disk usage is healthy: ${DISK_USAGE}%"
        return 0
    fi
}

# Check memory usage
check_memory_usage() {
    echo -e "\n${BLUE}=== Memory Usage Check ===${NC}"
    
    # Get memory statistics
    MEM_TOTAL=$(free -m | awk 'NR==2{print $2}')
    MEM_USED=$(free -m | awk 'NR==2{print $3}')
    MEM_PERCENT=$((MEM_USED * 100 / MEM_TOTAL))
    
    echo "Memory: ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PERCENT}%)"
    log_message "INFO" "Memory usage: ${MEM_USED}MB / ${MEM_TOTAL}MB (${MEM_PERCENT}%)"
    
    if [ "$MEM_PERCENT" -gt "$MEMORY_THRESHOLD" ]; then
        send_alert "CRITICAL" "Memory usage is ${MEM_PERCENT}% (threshold: ${MEMORY_THRESHOLD}%)"
        return 1
    elif [ "$MEM_PERCENT" -gt $((MEMORY_THRESHOLD - 10)) ]; then
        send_alert "WARNING" "Memory usage is ${MEM_PERCENT}% (approaching threshold)"
        return 0
    else
        send_alert "INFO" "Memory usage is healthy: ${MEM_PERCENT}%"
        return 0
    fi
}

# Check CPU load
check_cpu_load() {
    echo -e "\n${BLUE}=== CPU Load Check ===${NC}"
    
    # Get 1-minute load average
    CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    
    echo "Current CPU load (1-min avg): $CPU_LOAD"
    log_message "INFO" "CPU load: $CPU_LOAD"
    
    # Install bc if not present
    if ! command -v bc &> /dev/null; then
        sudo apt install bc -y &> /dev/null
    fi
    
    # Compare using bc for floating point
    if (( $(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l) )); then
        send_alert "CRITICAL" "CPU load is $CPU_LOAD (threshold: $CPU_THRESHOLD)"
        return 1
    else
        send_alert "INFO" "CPU load is healthy: $CPU_LOAD"
        return 0
    fi
}

# Check top processes
check_top_processes() {
    echo -e "\n${BLUE}=== Top CPU-Consuming Processes ===${NC}"
    
    echo "Top 5 processes by CPU usage:"
    ps aux --sort=-%cpu | head -6 | tail -5 | while read line; do
        echo "  $line"
    done
    
    log_message "INFO" "Top processes logged"
}

# System information
display_system_info() {
    echo -e "\n${BLUE}=== System Information ===${NC}"
    echo "Hostname: $(hostname)"
    echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Current user: $(whoami)"
    echo "Current time: $TIMESTAMP"
}

# Generate health report
generate_report() {
    echo -e "\n${BLUE}=== Generating Health Report ===${NC}"
    
    {
        echo "======================================"
        echo "Server Health Report"
        echo "Generated: $TIMESTAMP"
        echo "======================================"
        echo ""
        echo "SYSTEM INFORMATION:"
        echo "  Hostname: $(hostname)"
        echo "  Uptime: $(uptime -p)"
        echo ""
        echo "DISK USAGE:"
        df -h / | tail -1
        echo ""
        echo "MEMORY USAGE:"
        free -h | grep Mem
        echo ""
        echo "CPU LOAD:"
        echo "  Load Average: $(uptime | awk -F'load average:' '{print $2}')"
        echo ""
        echo "TOP PROCESSES:"
        ps aux --sort=-%cpu | head -6
        echo ""
        echo "======================================"
    } > "$REPORT_FILE"
    
    echo "✅ Report saved to: $REPORT_FILE"
    log_message "INFO" "Health report generated: $REPORT_FILE"
}

# Clean old logs
cleanup_old_logs() {
    echo -e "\n${BLUE}=== Cleaning Old Logs ===${NC}"
    
    find "$LOG_DIR" -name "monitor-*.log" -mtime +${LOG_RETENTION} -delete 2>/dev/null
    find "$REPORT_DIR" -name "health-report-*.txt" -mtime +${LOG_RETENTION} -delete 2>/dev/null
    
    echo "✅ Cleaned logs older than $LOG_RETENTION days"
    log_message "INFO" "Old logs cleaned (retention: $LOG_RETENTION days)"
}

#############################################
# Main Execution
#############################################

main() {
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Server Health Monitoring System     ║"
    echo "║   Real-Time Production Monitor        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_message "INFO" "=== Monitoring check started ==="
    
    # Display system info
    display_system_info
    
    # Run all checks
    check_disk_usage
    DISK_STATUS=$?
    
    check_memory_usage
    MEM_STATUS=$?
    
    check_cpu_load
    CPU_STATUS=$?
    
    check_top_processes
    
    # Generate report
    generate_report
    
    # Cleanup old logs
    cleanup_old_logs
    
    # Summary
    echo -e "\n${BLUE}=== Health Check Summary ===${NC}"
    
    TOTAL_CHECKS=3
    FAILED_CHECKS=$((DISK_STATUS + MEM_STATUS + CPU_STATUS))
    PASSED_CHECKS=$((TOTAL_CHECKS - FAILED_CHECKS))
    
    echo "Total checks: $TOTAL_CHECKS"
    echo -e "${GREEN}Passed: $PASSED_CHECKS${NC}"
    
    if [ $FAILED_CHECKS -gt 0 ]; then
        echo -e "${RED}Failed: $FAILED_CHECKS${NC}"
        log_message "WARNING" "Health check completed with $FAILED_CHECKS issues"
        exit 1
    else
        echo -e "${GREEN}All systems healthy! ✅${NC}"
        log_message "INFO" "Health check completed - all systems healthy"
        exit 0
    fi
}

# Run main function
main
