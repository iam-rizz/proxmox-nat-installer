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
    
    # Check for supported Debian versions
    if grep -q "Debian GNU/Linux 12" /etc/os-release; then
        DEBIAN_VERSION="12"
        DEBIAN_CODENAME="bookworm"
        print_status "Detected Debian 12 Bookworm"
    elif grep -q "Debian GNU/Linux 13" /etc/os-release; then
        DEBIAN_VERSION="13"
        DEBIAN_CODENAME="trixie"
        print_status "Detected Debian 13 Trixie"
    else
        print_error "This script requires Debian 12 Bookworm or Debian 13 Trixie"
        print_error "Current OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
        exit 1
    fi
    
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "No internet connection detected"
        exit 1
    fi
    
    print_success "System validation passed - Debian $DEBIAN_VERSION ($DEBIAN_CODENAME)"
}

set_hosts() {
    print_status "Configuring /etc/hosts file..."
    
    # Get IP address and hostname
    IP_ADDRESS=$(curl -s --max-time 2 ifconfig.me || echo "N/A")
    HOSTNAME=$(hostname)
    FQDN="${HOSTNAME}.$(dnsdomainname 2>/dev/null || echo 'localdomain')"
    
    if [ "$IP_ADDRESS" = "N/A" ]; then
        print_warning "Could not detect public IP address, using local IP"
        IP_ADDRESS=$(hostname -I | awk '{print $1}')
    fi
    
    print_status "IP Address: $IP_ADDRESS"
    print_status "Hostname: $HOSTNAME"
    print_status "FQDN: $FQDN"
    
    # Backup original hosts file
    cp /etc/hosts /etc/hosts.backup
    
    # Remove any existing entries for the hostname to avoid conflicts
    sed -i "/\s$HOSTNAME\s/d" /etc/hosts
    sed -i "/\s$HOSTNAME$/d" /etc/hosts
    
    # Remove hostname from 127.0.1.1 entry if it exists
    sed -i "s/127\.0\.1\.1.*$HOSTNAME.*//g" /etc/hosts
    sed -i '/^127\.0\.1\.1\s*$/d' /etc/hosts
    
    # Add proper entry for hostname resolution
    echo "$IP_ADDRESS    $FQDN $HOSTNAME" >> /etc/hosts
    
    print_success "Updated /etc/hosts file:"
    print_status "Added entry: $IP_ADDRESS    $FQDN $HOSTNAME"
    
    # Test hostname resolution
    if hostname --ip-address >/dev/null 2>&1; then
        RESOLVED_IP=$(hostname --ip-address)
        print_success "Hostname resolution test passed: $RESOLVED_IP"
    else
        print_warning "Hostname resolution test failed, but continuing..."
    fi
}

update_system() {
    print_status "Updating system packages..."
    apt update
    apt upgrade -y
    apt install gnupg cron -y
    print_success "System updated successfully"
}

modernize_sources() {
    if [ "$DEBIAN_VERSION" = "13" ]; then
        print_status "Modernizing all repository sources to deb822 format..."
        if command -v apt >/dev/null 2>&1; then
            if apt modernize-sources; then
                print_success "Repository sources modernized to deb822 format"
            else
                print_warning "Failed to modernize sources or command not available"
            fi
        else
            print_warning "apt modernize-sources command not available"
        fi
    else
        print_status "Skipping modernize-sources for Debian $DEBIAN_VERSION (only available for Debian 13+)"
    fi
}

add_proxmox_repo() {    
    print_status "Adding Proxmox VE repository for Debian $DEBIAN_VERSION ($DEBIAN_CODENAME)..."
    
    if [ "$DEBIAN_VERSION" = "13" ]; then
        # Debian 13 Trixie - use deb822 format
        print_status "Using deb822 format for Debian 13 Trixie..."
        
        cat > /etc/apt/sources.list.d/pve-install-repo.sources << EOL
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
Architectures: amd64
EOL
        
        # Download Trixie-specific keyring
        wget https://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg -O /usr/share/keyrings/proxmox-archive-keyring.gpg
        
        # Modernize existing sources to deb822 format if available
        print_status "Modernizing repository sources to deb822 format..."
        if command -v apt >/dev/null 2>&1; then
            apt modernize-sources 2>/dev/null || print_warning "apt modernize-sources not available or failed"
        fi
        
    else
        # Debian 12 Bookworm - use legacy format
        print_status "Using legacy format for Debian 12 Bookworm..."
        
        echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
        
        # Download Bookworm-specific keyring
        wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
    fi

    apt update
    
    print_success "Proxmox VE repository added successfully for Debian $DEBIAN_VERSION"
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
    
    # Pass Debian version to part 2 script
    echo "DEBIAN_VERSION=\"$DEBIAN_VERSION\"" > /home/debian_version.conf
    echo "DEBIAN_CODENAME=\"$DEBIAN_CODENAME\"" >> /home/debian_version.conf
    
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
    modernize_sources
    add_proxmox_repo
    install_proxmox_kernel
    setup_part2_script
    display_instructions
}

main "$@" 