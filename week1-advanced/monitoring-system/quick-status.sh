#!/bin/bash

# Quick Server Status Dashboard
# For instant health overview

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "┌─────────────────────────────────────────┐"
echo "│     QUICK SERVER STATUS DASHBOARD      │"
echo "└─────────────────────────────────────────┘"
echo -e "${NC}"

# System Info
echo -e "${BLUE}📊 SYSTEM INFO${NC}"
echo "  Hostname: $(hostname)"
echo "  Uptime: $(uptime -p)"
echo "  Time: $(date '+%Y-%m-%d %H:%M:%S')"

# Disk Status
echo -e "\n${BLUE}💾 DISK STATUS${NC}"
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
DISK_AVAIL=$(df -h / | tail -1 | awk '{print $4}')

if [ "$DISK_USAGE" -gt 80 ]; then
    echo -e "  ${RED}❌ Disk: ${DISK_USAGE}% used (Available: $DISK_AVAIL)${NC}"
elif [ "$DISK_USAGE" -gt 60 ]; then
    echo -e "  ${YELLOW}⚠️  Disk: ${DISK_USAGE}% used (Available: $DISK_AVAIL)${NC}"
else
    echo -e "  ${GREEN}✅ Disk: ${DISK_USAGE}% used (Available: $DISK_AVAIL)${NC}"
fi

# Memory Status
echo -e "\n${BLUE}🧠 MEMORY STATUS${NC}"
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}')
MEM_USED=$(free -h | awk 'NR==2{print $3}')
MEM_PERCENT=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')

if [ "$MEM_PERCENT" -gt 85 ]; then
    echo -e "  ${RED}❌ Memory: ${MEM_USED}/${MEM_TOTAL} (${MEM_PERCENT}%)${NC}"
elif [ "$MEM_PERCENT" -gt 70 ]; then
    echo -e "  ${YELLOW}⚠️  Memory: ${MEM_USED}/${MEM_TOTAL} (${MEM_PERCENT}%)${NC}"
else
    echo -e "  ${GREEN}✅ Memory: ${MEM_USED}/${MEM_TOTAL} (${MEM_PERCENT}%)${NC}"
fi

# CPU Status
echo -e "\n${BLUE}⚡ CPU STATUS${NC}"
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
CPU_CORES=$(nproc)
echo -e "  Load: ${CPU_LOAD} (${CPU_CORES} cores)"

# Top 3 Processes
echo -e "\n${BLUE}🔥 TOP PROCESSES${NC}"
ps aux --sort=-%cpu | head -4 | tail -3 | awk '{printf "  %s: %.1f%% CPU\n", $11, $3}'

# Recent Logs
echo -e "\n${BLUE}📝 RECENT ACTIVITY${NC}"
if [ -d "logs" ]; then
    LATEST_LOG=$(ls -t logs/monitor-*.log 2>/dev/null | head -1)
    if [ -f "$LATEST_LOG" ]; then
        echo "  Last check: $(stat -c %y "$LATEST_LOG" | cut -d. -f1)"
        CRITICAL_COUNT=$(grep -c "CRITICAL" "$LATEST_LOG" 2>/dev/null || echo 0)
        WARNING_COUNT=$(grep -c "WARNING" "$LATEST_LOG" 2>/dev/null || echo 0)
        
        if [ "$CRITICAL_COUNT" -gt 0 ]; then
            echo -e "  ${RED}❌ Critical alerts: $CRITICAL_COUNT${NC}"
        fi
        if [ "$WARNING_COUNT" -gt 0 ]; then
            echo -e "  ${YELLOW}⚠️  Warnings: $WARNING_COUNT${NC}"
        fi
        if [ "$CRITICAL_COUNT" -eq 0 ] && [ "$WARNING_COUNT" -eq 0 ]; then
            echo -e "  ${GREEN}✅ No alerts${NC}"
        fi
    else
        echo "  No monitoring logs found"
    fi
else
    echo "  Monitoring not yet run"
fi

echo ""
echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│  Run './server-health-monitor.sh' for  │${NC}"
echo -e "${CYAN}│  detailed health check                  │${NC}"
echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
