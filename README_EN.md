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

## 📋 Table of Contents

- [Features](#-features)
- [System Requirements](#-system-requirements)
- [Quick Start](#-quick-start)
- [Post-Installation](#-post-installation)
- [Custom MOTD](#-custom-motd)
- [TODO List](#-todo-list)
- [Troubleshooting](#-troubleshooting)
- [Script Features](#-script-features)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)
- [Support](#-support)
- [Language Support](#-language-support)

## ✨ Features

- 🚀 **Automated Installation** - 2-stage script for Proxmox VE installation
- 🔄 **Auto-Execution** - Part 2 script runs automatically after reboot via .bashrc
- 🎨 **Custom MOTD** - Professional Message of the Day with complete system information
- 🛡️ **Error Handling** - Good error handling and logging
- 🧹 **Auto-Cleanup** - Automatic cleanup of temporary files and .bashrc entries
- 🌐 **NAT Network** - NAT network setup for VMs and containers
- 📊 **System Monitoring** - Resource and Proxmox VE status monitoring
- 🔧 **Troubleshooting** - Complete troubleshooting guide
- 🌐 **Network Monitoring** - Automatic network connectivity monitoring with auto-restart
- 🔍 **Service Status** - Monitoring Proxmox VE service status (pve-cluster, pvedaemon, pveproxy, pvestatd)

## 💻 System Requirements

- **OS**: Debian 12 Bookworm (minimum)
- **Architecture**: AMD64/x86_64
- **RAM**: Minimum 4GB (recommended 8GB+)
- **Storage**: Minimum 32GB (recommended 100GB+)
- **Network**: Internet connection for downloading packages
- **Access**: Root access (sudo)

## 🚀 Quick Start

### Step 1: Download and Run Part 1 Script

```bash
wget https://raw.githubusercontent.com/iam-rizz/proxmox-nat-installer/main/install.sh
chmod +x install.sh
sudo ./install.sh
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
sudo ./install_proxmox2.sh
```

## 🏗️ Post-Installation

1. **Access Web Interface**
   - Open browser and access: `https://IP_ADDRESS:8006`
   - Login with username: `root` and system root password

2. **Setup Network Bridge**
   - In web interface, create Linux Bridge `vmbr0`
   - Add first network interface to bridge
   - Or use script: `COMING SOON`

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
║  Proxmox VE Services:                                        ║
║  • pve-cluster: OK/FAILED                                    ║
║  • pvedaemon: OK/FAILED                                      ║
║  • pveproxy: OK/FAILED                                       ║
║  • pvestatd: OK/FAILED                                       ║
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
- ✅ **Proxmox VE status** (version, VM count, container count)
- ✅ **Resource monitoring** (CPU, RAM, Disk)
- ✅ **Quick commands** for admin
- ✅ **Disable default Debian MOTD**
- ✅ **Service Status Monitoring** (pve-cluster, pvedaemon, pveproxy, pvestatd)
- ✅ **Network Information** with real-time IP address

## 📋 TODO List

### 🔧 **Phase 1: Core Infrastructure**
- [x] **Installation Scripts**
  - [x] Automated Proxmox VE installation
  - [x] Custom MOTD implementation
  - [x] Error handling and logging
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

## 🔧 Troubleshooting

### Network not working
- Check `/etc/hosts` configuration
- Ensure hostname can be resolved to IP address

### DNS issues
- Don't install `resolvconf` or `rdnssd` packages
- Proxmox VE manages DNS itself

### Part 2 Script Not Running Automatically
```bash
tail -20 /root/.bashrc
ls -la /home/install_proxmox2.sh
sudo /home/install_proxmox2.sh
```

### MOTD not appearing
```bash
sudo /usr/local/bin/pve-motd.sh
crontab -l | grep pve-motd
sudo systemctl restart update-motd
```

### Installation Logs
To view installation logs:
```bash
tail -20 /root/.bashrc
ls -la /home/install_proxmox2.sh
journalctl -u pveproxy
journalctl -u pvedaemon
```

## 🛡️ Script Features

- ✅ System validation (Debian 12, root access)
- ✅ Auto-run part 2 script after reboot using .bashrc
- ✅ Error handling and logging
- ✅ Automatic cleanup of .bashrc entry and temporary files
- ✅ Colored messages for easy reading
- ✅ Custom MOTD with complete Proxmox VE information
- ✅ Service Status Monitoring for Proxmox VE services

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

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Proxmox VE Team](https://www.proxmox.com/) for the amazing software
- [Debian Project](https://www.debian.org/) for the stable operating system
- Open source community for inspiration and support

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/iam-rizz/proxmox-nat-installer/issues)

## 🌐 Language Support

- 🇮🇩 **Indonesian**: [README.md](README.md) | [CONTRIBUTING.md](CONTRIBUTING.md)
- 🇺🇸 **English**: [README_EN.md](README_EN.md) | [CONTRIBUTING_EN.md](CONTRIBUTING_EN.md)

---

**Made with ❤️ by [iam-rizz](https://github.com/iam-rizz)**
