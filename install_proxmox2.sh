#!/bin/bash

# Proxmox VE Installation Script - Part 2
# Auto-executed via .bashrc after reboot
# Author: iam-rizz
# Date: 2025
clear
sleep 2
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
IP_PUBLIC=$(curl -s --max-time 2 ifconfig.me || echo "N/A")

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

remove_bashrc_entry() {
    print_status "Removing .bashrc entry..."
    
    # Create a temporary file to store the cleaned .bashrc
    temp_bashrc=$(mktemp)
    
    # Remove the entire auto-run block from .bashrc
    awk '
    /^# Auto-run Proxmox installer/ { 
        # Start of block found, skip until we find the end
        while ((getline line) > 0) {
            if (line ~ /^fi$/ && prev_line ~ /^    fi$/) {
                # Found the end of our block
                break
            }
            prev_line = line
        }
        next
    }
    { print }
    { prev_line = $0 }
    ' /root/.bashrc > "$temp_bashrc"
    
    # Replace the original .bashrc with cleaned version
    mv "$temp_bashrc" /root/.bashrc
    
    print_success "Removed .bashrc entry"
}

self_destruct() {
    print_status "Cleaning up installation files..."
    remove_bashrc_entry
    
    rm -f /home/install_proxmox2.sh /root/install_proxmox2.sh > /dev/null 2>&1
    rm -f /home/debian_version.conf > /dev/null 2>&1
    print_success "Installation completed and cleaned up!"
}

install_proxmox() {
    print_status "Starting Proxmox VE installation (Part 2)..."
    
    # Load Debian version info
    if [ -f /home/debian_version.conf ]; then
        source /home/debian_version.conf
        print_status "Detected Debian $DEBIAN_VERSION ($DEBIAN_CODENAME)"
    else
        # Fallback detection
        if grep -q "Debian GNU/Linux 12" /etc/os-release; then
            DEBIAN_VERSION="12"
            DEBIAN_CODENAME="bookworm"
        elif grep -q "Debian GNU/Linux 13" /etc/os-release; then
            DEBIAN_VERSION="13"
            DEBIAN_CODENAME="trixie"
        else
            print_error "Could not detect Debian version"
            exit 1
        fi
    fi
    
    print_status "Updating system packages..."
    apt update
    
    print_status "Installing Proxmox VE packages..."
    apt install -y proxmox-ve postfix open-iscsi chrony
    
    print_status "Removing Debian kernel..."
    if [ "$DEBIAN_VERSION" = "13" ]; then
        # Debian 13 uses kernel 6.12.x
        apt remove -y linux-image-amd64 'linux-image-6.12*'
    else
        # Debian 12 uses kernel 6.1.x
        apt remove -y linux-image-amd64 'linux-image-6.1*'
    fi
    
    print_status "Updating GRUB configuration..."
    update-grub
    
    print_status "Removing os-prober..."
    apt remove -y os-prober
    
    print_status "Cleaning up packages..."
    apt autoremove -y
    apt autoclean
    
    print_success "Proxmox VE packages installed successfully!"
}

setup_motd() {
    print_status "Setting up custom MOTD..."
    
    cat > /usr/local/bin/pve-motd.sh << 'EOF'
#!/bin/bash
clear
# Proxmox VE Custom MOTD
# Displays system information and Proxmox status

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              "
echo "║                    PROXMOX VIRTUAL ENVIRONMENT               "
echo "║                                                              "

# System Information
echo "║  System Information:                                         "
echo "║  • Hostname: $(hostname)                                     "
echo "║  • Kernel: $(uname -r)                                       "
echo "║  • Uptime: $(uptime -p | sed 's/up //')                      "
echo "║  • Load Average: $(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}') "
echo "║                                                              "

# Network Information
IP=$(curl -s --max-time 2 ifconfig.me || echo "N/A")
echo "║  Network Information:                                        "
echo "║  • IP Address: $IP                                           "
echo "║  • Web Interface: https://$IP:8006                           "
echo "║                                                              "

# Proxmox VE Status
PVE_VERSION=$(pveversion -v | head -1 | awk '{print $2}')
VM_COUNT=$(qm list 2>/dev/null | wc -l)
CT_COUNT=$(pct list 2>/dev/null | wc -l)

echo "║  Proxmox VE Status:                                          "
echo "║  • Version: $PVE_VERSION                                     "
echo "║  • VMs: $VM_COUNT                                            "
echo "║  • Containers: $CT_COUNT                                     "
echo "║                                                              "

echo "║  Proxmox VE Services:                                        "
# Function to check service status
check_service() {
    local service=$1
    local status=$(systemctl is-active "$service" 2>/dev/null)
    if [ "$status" = "active" ]; then
        echo "║  • $service: OK                                        "
    else
        echo "║  • $service: FAILED                                    "
    fi
}

check_service "pve-cluster"
check_service "pvedaemon"
check_service "pveproxy"
check_service "pvestatd"
echo "║                                                              "

# System Resources
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
MEM_USAGE=$(free | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "║  System Resources:                                           "
echo "║  • CPU Usage: ${CPU_USAGE}%                                  "
echo "║  • Memory Usage: ${MEM_USAGE}%                               "
echo "║  • Disk Usage: ${DISK_USAGE}%                                "
echo "║                                                              "

echo "║  Quick Commands:                                             "
echo "║  • pvesm status    - Storage status                          "
echo "║  • qm list         - List VMs                                "
echo "║  • pct list        - List containers                         "
echo "║  • systemctl status pveproxy - Web interface status          "
echo "║                                                              "
echo "╚══════════════════════════════════════════════════════════════╝"
EOF

    chmod +x /usr/local/bin/pve-motd.sh
    
    print_status "Disabling default MOTD..."
    chmod -x /etc/update-motd.d/*
    
    cat > /etc/update-motd.d/01-pve-custom << 'EOF'
#!/bin/bash
/usr/local/bin/pve-motd.sh
EOF
    
    chmod +x /etc/update-motd.d/01-pve-custom
    
    (crontab -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/pve-motd.sh > /etc/motd") | crontab -
    
    /usr/local/bin/pve-motd.sh > /etc/motd
    
    print_success "Custom MOTD setup completed!"
    
    # Create separate network connectivity monitoring script
    print_status "Setting up network connectivity monitoring..."
    
    cat > /usr/local/bin/network-monitor.sh << 'EOF'
#!/bin/bash

# Network Connectivity Monitoring Script
# Checks if ping fails 2-3 times and restarts networking
# Author: iam-rizz
# Date: 2025

LOG_FILE="/var/log/network-monitor.log"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

check_network_connectivity() {
    local ping_target="8.8.8.8"
    local max_failures=3
    local failure_count=0
    
    # Check network connectivity with ping
    for i in {1..3}; do
        if ! ping -c 1 -W 3 "$ping_target" >/dev/null 2>&1; then
            ((failure_count++))
            log_message "Network ping attempt $i failed"
        else
            if [ $failure_count -gt 0 ]; then
                log_message "Network connectivity restored after $failure_count failures"
            fi
            return 0
        fi
    done
    
    if [ $failure_count -ge $max_failures ]; then
        log_message "Network connectivity lost. Restarting networking service..."
        systemctl restart networking
        log_message "Networking service restarted"
        
        sleep 5
        if ping -c 1 -W 3 "$ping_target" >/dev/null 2>&1; then
            log_message "Network connectivity restored after restart"
        else
            log_message "Network connectivity still failed after restart"
        fi
    fi
}

check_network_connectivity
EOF

    chmod +x /usr/local/bin/network-monitor.sh
    
    cat >> /root/.bashrc << 'EOF'

# Network Connectivity Monitoring
# Run network connectivity check on every login
if [ -f /usr/local/bin/network-monitor.sh ]; then
    /usr/local/bin/network-monitor.sh
fi

EOF

    print_success "Network connectivity monitoring script created!"
    print_status "Script location: /usr/local/bin/network-monitor.sh"
    print_status "The script will check network connectivity on every login and restart networking if ping fails 2-3 times"
    print_status "Logs will be written to /var/log/network-monitor.log"
}

main() {
    print_status "Proxmox VE Installation Part 2 Started"
    print_status "This script will run automatically after reboot"
    
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
    
    if ! uname -r | grep -q pve; then
        print_error "Proxmox kernel is not loaded. Please reboot first."
        exit 1
    fi
    
    install_proxmox
    setup_motd
    self_destruct
    
    print_success "Proxmox VE installation completed successfully!"
    print_status "You can now access the web interface at: https://$IP_PUBLIC:8006"
}

main "$@"