# !/bin/bash # #!: tells the system that this file should be executed using a specific interpreter,/bin/bash: tells the system that this file should be executed using a specific interpreter.

#!/bin/bash

# ============================================
# Advanced Bash Scripting - Fundamentals
# ============================================

echo "=== Module 1: Variables & Command Substitution ==="

# Variables
USERNAME=$(whoami)
CURRENT_DIR=$(pwd)
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

echo "User: $USERNAME"
echo "Directory: $CURRENT_DIR"
echo "Date: $DATE"
echo "Time: $TIME"

# ============================================
echo ""
echo "=== Module 2: Conditionals (if/else) ==="

# Get disk usage percentage
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "Current disk usage: ${DISK_USAGE}%"

if [ $DISK_USAGE -gt 80 ]; then
    echo "❌ CRITICAL: Disk usage is above 80%!"
elif [ $DISK_USAGE -gt 60 ]; then
    echo "⚠️  WARNING: Disk usage is above 60%"
else
    echo "✅ OK: Disk usage is healthy"
fi

# ============================================
echo ""
echo "=== Module 3: Loops (for loop) ==="

echo "Checking system services:"
SERVICES=("ssh" "cron" "systemd")

for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet $service 2>/dev/null; then
        echo "  ✅ $service is running"
    else
        echo "  ❌ $service is not running (or not available)"
    fi
done

# ============================================
echo ""
echo "=== Module 4: Functions ==="

# Define a function
check_memory() {
    local mem_total=$(free -m | awk 'NR==2{print $2}')
    local mem_used=$(free -m | awk 'NR==2{print $3}')
    local mem_percent=$((mem_used * 100 / mem_total))
    
    echo "Memory Usage: ${mem_used}MB / ${mem_total}MB (${mem_percent}%)"
    
    if [ $mem_percent -gt 80 ]; then
        return 1  # Error code
    else
        return 0  # Success code
    fi
}

# Call the function
if check_memory; then
    echo "✅ Memory usage is healthy"
else
    echo "❌ WARNING: Memory usage is high!"
fi

# ============================================
echo ""
echo "=== Module 5: Error Handling ==="

# Check if a file exists
CONFIG_FILE="/etc/hostname"

if [ -f "$CONFIG_FILE" ]; then
    echo "✅ Config file exists: $CONFIG_FILE"
    echo "   Content: $(cat $CONFIG_FILE)"
else
    echo "❌ Config file not found: $CONFIG_FILE"
    exit 1
fi

echo "=== Module 6: Checking if CPU load is above 2.0 ==="
CPU_USAGE=$(uptime | awk '{print $(NF-2)}' | sed 's/,//')
echo "Current CPU Load: $CPU_USAGE"
# Note: Using bc for floating point comparison
if (( $(echo "$CPU_USAGE > 2.0" | bc -l) )); then
   echo "❌ CPU Usage is above 2.0"
else
   echo "✅ CPU Usage is below 2.0"
fi

echo ""
echo "=== Module 7: Checking last 5 logged-in users ==="
last_users=$(last | awk '{print $1}' | head -n 5)
# Loop through them
count=1
for user in $last_users; do
   echo "User #$count: $user"
   ((count++))
done

echo ""
echo "=== Module 8: Function to check whether a directory exists or not ==="
check_directory() {
   local dir_path="$1"
   if [ -d "$dir_path" ]; then
      echo "✅ Directory exists: $dir_path"
   else
      echo "❌ Directory does not exist: $dir_path"
   fi
}

# Test the function
check_directory "/home/satish"
check_directory "/home/satish/devops-project"
check_directory "/nonexistent/path"

echo ""
echo "=== Script Completed Successfully ==="

echo "=== Script Completed Successfully ==="
exit 0
