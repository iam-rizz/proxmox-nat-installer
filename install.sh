#!/bin/bash

# Proxmox VE Installation Script - Part 1
# Installs Proxmox kernel and sets up auto-execution via .bashrc
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

validate_system() {
    print_status "Validating system requirements..."
    
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
    
    if ! grep -q "Debian GNU/Linux 12" /etc/os-release; then
        print_error "This script requires Debian 12 Bookworm"
        print_error "Current OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
        exit 1
    fi
    
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "No internet connection detected"
        exit 1
    fi
    
    print_success "System validation passed"
}

set_hosts() {
    IP_ADDRESS=$(curl -s --max-time 2 ifconfig.me || echo "N/A")
    HOSTNAME=$(hostname)
    sudo sed -i "s/^127\.0\.1\.1.*/$IP_ADDRESS\t$HOSTNAME/" /etc/hosts
    echo "File /etc/hosts telah diperbarui:"
}

update_system() {
    print_status "Updating system packages..."
    apt update
    apt upgrade -y
    apt install gnupg cron -y
    print_success "System updated successfully"
}

add_proxmox_repo() {    
    print_status "Adding Proxmox VE repository..."
    
    echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
    
    wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 

    apt update
    
    print_success "Proxmox VE repository added successfully"
}


install_proxmox_kernel() {
    print_status "Installing Proxmox VE kernel..."
    
    apt install proxmox-default-kernel -y
    
    print_success "Proxmox VE kernel installed successfully"
}

setup_part2_script() {
    print_status "Setting up part 2 script for auto-execution via .bashrc..."
    wget https://raw.githubusercontent.com/iam-rizz/proxmox-nat-installer/main/install_proxmox2.sh
    cp install_proxmox2.sh /home/install_proxmox2.sh
    chmod +x /home/install_proxmox2.sh
    rm -f install_proxmox2.sh
    
    print_status "Adding auto-execution to .bashrc..."
    cat >> /root/.bashrc << 'EOF'

# Auto-run Proxmox installer (will be removed automatically)
if [ -f /home/install_proxmox2.sh ]; then
    bash /home/install_proxmox2.sh
fi
EOF
    
    print_success "Part 2 script setup completed"
    print_status "Script will auto-execute after reboot via .bashrc"
}

display_instructions() {
    echo
    print_success "Proxmox VE Installation Part 1 Completed!"
    echo
    print_status "Next steps:"
    echo "1. Reboot the system: sudo systemctl reboot"
    echo "2. After reboot, part 2 script will run automatically via .bashrc"
    echo "3. Installation will complete automatically"
    echo "4. Access web interface at: https://$IP_PUBLIC:8006"
    echo
    print_warning "Important: Do not interrupt the reboot process!"
    echo
}

main() {
    print_status "Proxmox VE Installation Part 1 Started"
    print_status "This script will install Proxmox kernel and setup auto-execution via .bashrc"
    validate_system
    set_hosts
    update_system
    add_proxmox_repo
    install_proxmox_kernel
    setup_part2_script
    display_instructions
}

main "$@" 