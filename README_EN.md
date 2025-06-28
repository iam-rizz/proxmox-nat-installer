# Proxmox VE NAT Network Project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Debian](https://img.shields.io/badge/Debian-12%20Bookworm-red.svg)](https://www.debian.org/)
[![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-8.x-orange.svg)](https://www.proxmox.com/)
[![GitHub Views](https://komarev.com/ghpvc/?username=iam-rizz&repo=proxmox-nat-installer&color=blue&style=flat-square)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Stars](https://img.shields.io/github/stars/iam-rizz/proxmox-nat-installer?style=social)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Forks](https://img.shields.io/github/forks/iam-rizz/proxmox-nat-installer?style=social)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Issues](https://img.shields.io/github/issues/iam-rizz/proxmox-nat-installer)](https://github.com/iam-rizz/proxmox-nat-installer/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/iam-rizz/proxmox-nat-installer)](https://github.com/iam-rizz/proxmox-nat-installer/pulls)

**Open Source Project** for installing and configuring Proxmox Virtual Environment (PVE) with NAT networking for Virtual Machines (VMs) and Containers.

## 📋 About the Project

This project provides a complete solution for setting up Proxmox VE servers using NAT (Network Address Translation) networking to efficiently isolate and manage VMs/Containers. Ideal for development environments, testing, or production deployments requiring network isolation.

### 🎯 Project Goals

- **Automated Installation**: Automated scripts for installing Proxmox VE on Debian 12
- **NAT Networking**: Secure and isolated NAT network setup
- **API Management**: REST API for managing iptables NAT rules
- **Port Forwarding**: Tools for managing port forwarding and domain routing
- **Monitoring**: Custom MOTD and monitoring tools

## 🌐 What is NAT Networking?

**Network Address Translation (NAT)** is a technique that allows multiple devices in a private network to share a single public IP address. In the context of Proxmox VE:

### 🔒 Benefits of NAT for VMs/Containers:

- **Security Isolation**: VMs/Containers are not directly exposed to the internet
- **IP Management**: Uses private IP ranges (192.168.x.x, 10.x.x.x)
- **Port Forwarding**: Complete control over internet access
- **Resource Efficiency**: Saves public IP addresses
- **Firewall Control**: Centralized security management

### 📊 Network Architecture:

```
Internet
    │
    ▼
[Router/Gateway]
    │ (Public IP)
    ▼
[Proxmox Host]
    │ (NAT Gateway)
    ▼
[VM/Container Network]
    ├── VM1 (192.168.1.10)
    ├── VM2 (192.168.1.11)
    ├── Container1 (192.168.1.20)
    └── Container2 (192.168.1.21)
```

## 🚀 Key Features

### ✅ **Automated Installer**
- Bash scripts for installing Proxmox VE on Debian 12
- Auto-run using cron @reboot
- Custom MOTD with real-time system information
- Comprehensive error handling and logging

### ✅ **NAT Bridge Configuration**
- Linux bridge setup with NAT
- IP forwarding and masquerading
- DHCP server for VMs/Containers
- Automated firewall rules

### ✅ **API Management**
- REST API for managing iptables NAT rules
- CRUD operations for port forwarding
- Authentication and authorization
- JSON-based configuration

### ✅ **Port Forwarding Tools**
- Web interface for port management
- Domain-based routing
- SSL/TLS certificate management
- Load balancing support

## 🚀 Quick Start

### Step 1: Download and Run Part 1 Script

```bash
COMING SOON
```

This script will:
- Update system
- Add Proxmox VE repository
- Download and verify GPG key
- Install Proxmox VE kernel
- Setup part 2 script for auto-run after reboot using .bashrc

### Step 2: Reboot System

```bash
sudo systemctl reboot
```

### Step 3: Part 2 Script Runs Automatically

After reboot, part 2 script will automatically run via .bashrc and:
- Install Proxmox VE packages
- Remove Debian kernel
- Update GRUB
- Remove os-prober
- **Setup Custom MOTD** for Proxmox VE
- Cleanup .bashrc entry and temporary files

### Alternative: Run Part 2 Script Manually

If part 2 script doesn't run automatically, run manually:

```bash
COMING SOON
```

## 🏗️ Post-Installation

1. **Access Web Interface**
   - Open browser and access: `https://IP_ADDRESS:8006`
   - Login with username: `root` and system root password

2. **Setup Network Bridge**
   - In web interface, create Linux Bridge `vmbr0`
   - Add first network interface to bridge
   - Or use script: `sudo ./setup_network_bridge.sh`

3. **Upload Subscription Key (Optional)**
   - If you have a subscription, upload key in web interface
   - Remove no-subscription repository:
     ```bash
     sudo rm /etc/apt/sources.list.d/pve-install-repo.list
     ```

## 📊 Custom MOTD (Message of the Day)

Part 2 script will automatically setup custom MOTD that displays complete Proxmox VE system information on every login:

```
╔══════════════════════════════════════════════════════════════╗
║                    PROXMOX VIRTUAL ENVIRONMENT               ║
║                                                              ║
║  System Information:                                         ║
║  • Hostname: [hostname]                                      ║
║  • Kernel: [kernel version]                                  ║
║  • Uptime: [uptime]                                          ║
║  • Load Average: [load]                                      ║
║                                                              ║
║  Network Information:                                        ║
║  • IP Address: [IP address]                                  ║
║  • Web Interface: https://[IP]:8006                          ║
║                                                              ║
║  Proxmox VE Status:                                          ║
║  • Version: [PVE version]                                    ║
║  • VMs: [VM count]                                           ║
║  • Containers: [container count]                             ║
║                                                              ║
║  System Resources:                                           ║
║  • CPU Usage: [CPU %]                                        ║
║  • Memory Usage: [RAM %]                                     ║
║  • Disk Usage: [Disk %]                                      ║
║                                                              ║
║  Quick Commands:                                             ║
║  • pvesm status    - Storage status                          ║
║  • qm list         - List VMs                                ║
║  • pct list        - List containers                         ║
║  • systemctl status pveproxy - Web interface status          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

### MOTD Features:
- ✅ **Auto-update** every 5 minutes
- ✅ **Real-time system information**
- ✅ **Proxmox VE status** (version, VM, container count)
- ✅ **Resource monitoring** (CPU, RAM, Disk)
- ✅ **Quick commands** for admin
- ✅ **Disable default Debian MOTD**

## 📋 TODO List

### 🔧 **Phase 1: Core Infrastructure**
- [ ] **Installation Scripts**
  - [ ] Automated Proxmox VE installation
  - [ ] Custom MOTD implementation
  - [ ] Error handling and logging
  - [ ] Multi-distribution support (Ubuntu, CentOS)
  - [ ] Unattended installation mode

- [ ] **NAT Bridge Configuration**
  - [ ] Automated NAT bridge setup
  - [ ] DHCP server configuration
  - [ ] IP forwarding and masquerading
  - [ ] Firewall rules automation
  - [ ] Network isolation policies

### 🌐 **Phase 2: Network Management**
- [ ] **API Server for iptables NAT**
  - [ ] REST API development (Node.js/Python)
  - [ ] iptables NAT rules management
  - [ ] Authentication and authorization
  - [ ] Rate limiting and security
  - [ ] API documentation (Swagger/OpenAPI)

- [ ] **Port Forwarding Tools**
  - [ ] Web-based port management interface
  - [ ] Domain-based routing system
  - [ ] SSL/TLS certificate management
  - [ ] Load balancing configuration
  - [ ] Health monitoring and failover

### 📊 **Phase 3: System Monitoring**
- [ ] **Resource Monitoring**
  - [ ] CPU, RAM, Disk usage tracking
  - [ ] Network bandwidth monitoring
  - [ ] VM and container resource usage
  - [ ] Storage performance metrics
  - [ ] Real-time alerts and notifications

- [ ] **Log Management**
  - [ ] Centralized log collection
  - [ ] Log rotation and retention
  - [ ] Error pattern detection
  - [ ] Security event monitoring
  - [ ] Performance bottleneck analysis

- [ ] **Health Checks**
  - [ ] Service status monitoring
  - [ ] Network connectivity tests
  - [ ] Backup verification
  - [ ] Certificate expiration alerts
  - [ ] System update notifications


## 🛡️ Script Features

- ✅ System validation (Debian 12, root access)
- ✅ GPG key verification
- ✅ Auto-run part 2 script after reboot using .bashrc
- ✅ Error handling and logging
- ✅ Automatic cleanup of .bashrc entry and temporary files
- ✅ Colored messages for easy reading
- ✅ Self-destruct part 2 script after completion
- ✅ **Custom MOTD** with complete Proxmox VE information

## 🤝 Contributing

We welcome contributions from the community! Please:

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 📝 Guidelines
- Follow existing coding standards
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Proxmox VE Team](https://www.proxmox.com/) for the amazing software
- [Debian Project](https://www.debian.org/) for the stable operating system
- Open source community for inspiration and support

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/iam-rizz/proxmox-nat-installer/issues)

## 🌐 Language Support

This project supports both Indonesian and English documentation:

### 🇮🇩 **Indonesian**
- **README**: [README.md](README.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)

### 🇺🇸 **English**
- **README**: [README_EN.md](README_EN.md)
- **Contributing**: [CONTRIBUTING_EN.md](CONTRIBUTING_EN.md)

Choose the language you're most comfortable with. All contributions are welcome in both languages.

## 📚 References

- [Proxmox VE Installation Guide](https://pve.proxmox.com/wiki/Install_Proxmox_VE_on_Debian_12_Bookworm)
- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [Proxmox VE Forum](https://forum.proxmox.com/)
- [Linux NAT Documentation](https://www.netfilter.org/documentation/)
- [iptables Tutorial](https://www.netfilter.org/documentation/HOWTO/NAT-HOWTO.html)

---

**⭐ If this project helps you, please give it a star on the repository!** 