# DevOps Learning Journey 🚀

## Project Overview
Production-ready DevOps projects and automation tools built during my transformation from Full-Stack Developer to DevOps Engineer.

## 🎯 Current Progress

### Week 1: Linux & Bash Mastery ✅
- [x] WSL2 Ubuntu setup and configuration
- [x] Linux command line proficiency
- [x] Advanced bash scripting (variables, loops, functions, conditionals)
- [x] System monitoring and health checks
- [x] Git workflows and authentication
- [x] File permissions and security
- [x] Production monitoring system deployment
- [x] Cron job automation
- [x] Log management and rotation

## 📊 Projects

### 1. Production Server Health Monitoring System
**Location:** `week1-advanced/monitoring-system/`

A enterprise-grade monitoring system that tracks server health in real-time.

**Features:**
- ✅ Real-time disk, memory, and CPU monitoring
- ✅ Three-tier alerting (CRITICAL, WARNING, INFO)
- ✅ Configurable thresholds
- ✅ Automated logging with timestamps
- ✅ Daily health report generation
- ✅ Log rotation and cleanup (7-day retention)
- ✅ Cron job automation
- ✅ Color-coded terminal output
- ✅ Quick status dashboard

**Tech Stack:** Bash, Linux system utilities, Cron

**Usage:**
```bash
# Full health check
./server-health-monitor.sh

# Quick status dashboard
./quick-status.sh

# Setup automated monitoring
./setup-cron.sh

# Using aliases (after setup)
status        # Quick dashboard
monitor       # Full health check
monitor-logs  # View logs in real-time
```

**Real-world application:** This type of monitoring runs on production servers managing millions in revenue.

---

### 2. System Information Script
**Location:** `system-info.sh`

Basic system monitoring dashboard displaying:
- Current user and directory
- System information and uptime
- Disk usage
- Memory utilization
- Top CPU-consuming processes

**Usage:**
```bash
chmod +x system-info.sh
./system-info.sh
```

---

## 🛠️ Skills Demonstrated

### Linux Administration
- Command line proficiency (navigation, file operations)
- User and permission management
- System monitoring and troubleshooting
- Process management
- Service administration

### Bash Scripting
- Variables and command substitution
- Conditionals and loops
- Functions with parameters
- Error handling and exit codes
- Script automation
- Log file management

### DevOps Practices
- Infrastructure monitoring
- Automated alerting
- Log aggregation and rotation
- Configuration management
- Cron job scheduling
- Version control with Git

### Problem Solving
- Debugging permission errors
- WSL configuration issues
- Git authentication setup
- Threshold-based alerting logic

---

## 📈 Metrics

**Lines of Code:** 500+
**Scripts Created:** 5+
**Automated Checks:** 3 (Disk, Memory, CPU)
**Log Retention:** 7 days
**Monitoring Frequency:** Configurable (hourly recommended)

---

## 🎓 Learning Resources

- Linux command line documentation
- Bash scripting best practices
- Git official documentation
- DevOps monitoring strategies
- Production system reliability

---

## 🚀 Next Steps

### Week 2: Advanced Git & CI/CD (In Progress)
- [ ] Git branching strategies (GitFlow, feature branches)
- [ ] Merge vs Rebase workflows
- [ ] Git hooks for automation
- [ ] Pull requests and code reviews
- [ ] Jenkins CI/CD pipeline basics

### Week 3: Docker & Containerization
- [ ] Docker fundamentals
- [ ] Dockerfile creation and optimization
- [ ] Multi-stage builds
- [ ] Docker Compose for multi-container apps
- [ ] Container registry (Docker Hub, ECR)

### Week 4: AWS & Cloud Infrastructure
- [ ] EC2 deployment
- [ ] VPC and security groups
- [ ] Load balancers and auto-scaling
- [ ] Infrastructure as Code basics
- [ ] Cloud monitoring integration

---

## 📂 Project Structure
```
devops-project/
├── system-info.sh                    # Basic monitoring script
├── week1-advanced/
│   ├── 01-bash-fundamentals.sh      # Bash learning exercises
│   └── monitoring-system/
│       ├── server-health-monitor.sh  # Main monitoring script
│       ├── quick-status.sh          # Quick status dashboard
│       ├── setup-cron.sh            # Automation setup
│       ├── config/
│       │   └── thresholds.conf      # Configurable thresholds
│       ├── logs/                    # Automated logs
│       └── reports/                 # Daily health reports
└── README.md
```

---

## 💡 Key Learnings

### Technical
1. **Errors are teachers** - Permission denied errors taught me Linux security
2. **Automation saves time** - Cron jobs eliminate manual monitoring
3. **Logging is crucial** - Can't troubleshoot what you can't see
4. **Configuration matters** - Separate config from code for flexibility

### Process
1. **Build, don't just learn** - Hands-on projects beat tutorials
2. **Learn in public** - Community feedback accelerates growth
3. **Document everything** - Future self will thank you
4. **Iterate quickly** - Start simple, improve incrementally

---

## 🌟 Why This Matters

These aren't toy projects - they're production-ready tools:
- Used by companies managing $100M+ infrastructure
- Prevent downtime that costs thousands per minute
- Scale from single servers to distributed systems
- Follow industry best practices

**Learning by building real solutions, not following tutorials.**

---

## 📞 Connect

**GitHub:** [@SK2201434](https://github.com/SK2201434)

**Learning in public:** Follow my journey from Full-Stack Developer to DevOps Engineer

**Feedback welcome!** Open issues or PRs if you have suggestions.

---

## 📜 License

MIT License - Feel free to use these scripts in your own learning journey!

---

**⭐ Star this repo if you found it useful!**

**🔄 Fork it to start your own DevOps journey!**

**💬 Open an issue if you have questions!**

---

*Last updated: October 2025*
*Status: Active Development - Week 1 Complete ✅*
