# Proxmox VE NAT Network Project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Debian](https://img.shields.io/badge/Debian-12%20%7C%2013-red.svg)](https://www.debian.org/)
[![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-8.x%20%7C%209.x-orange.svg)](https://www.proxmox.com/)
[![GitHub Views](https://komarev.com/ghpvc/?username=iam-rizz&repo=proxmox-nat-installer&color=blue&style=flat-square)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Stars](https://img.shields.io/github/stars/iam-rizz/proxmox-nat-installer?style=social)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Forks](https://img.shields.io/github/forks/iam-rizz/proxmox-nat-installer?style=social)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Issues](https://img.shields.io/github/issues/iam-rizz/proxmox-nat-installer)](https://github.com/iam-rizz/proxmox-nat-installer/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/iam-rizz/proxmox-nat-installer)](https://github.com/iam-rizz/proxmox-nat-installer/pulls)

**Open Source Project** untuk menginstall dan mengkonfigurasi Proxmox Virtual Environment (PVE) dengan jaringan NAT untuk Virtual Machines (VMs) dan Containers.

## 📋 Daftar Isi

- [Fitur](#-fitur)
- [Persyaratan Sistem](#-persyaratan-sistem)
- [Quick Start](#-quick-start)
- [Post-Installation](#-post-installation)
- [Custom MOTD](#-custom-motd)
- [Network Connectivity Monitoring](#-network-connectivity-monitoring)
- [TODO List](#-todo-list)
- [Troubleshooting](#-troubleshooting)
- [Script Features](#-script-features)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)
- [Support](#-support)
- [Language Support](#-language-support)

## ✨ Fitur

- 🚀 **Instalasi Otomatis** - Script 2 tahap untuk instalasi Proxmox VE
- 🔄 **Auto-Execution** - Script part 2 berjalan otomatis setelah reboot via .bashrc
- 🎨 **Custom MOTD** - Message of the Day profesional dengan info sistem lengkap
- 🛡️ **Error Handling** - Penanganan error dan logging yang baik
- 🧹 **Auto-Cleanup** - Pembersihan otomatis file temporary dan .bashrc entry
- 🌐 **NAT Network** - Setup jaringan NAT untuk VMs dan containers
- 📊 **System Monitoring** - Monitoring resource dan status Proxmox VE
- 🔧 **Troubleshooting** - Panduan troubleshooting lengkap
- 🌐 **Network Monitoring** - Monitoring konektivitas jaringan otomatis dengan auto-restart
- 🔍 **Service Status** - Monitoring status layanan Proxmox VE (pve-cluster, pvedaemon, pveproxy, pvestatd)
- 🔄 **Multi-Version Support** - Support Debian 12 Bookworm dan Debian 13 Trixie
- 📁 **Repository Format** - Otomatis menggunakan format yang sesuai (legacy/deb822)
- 🔄 **Sources Modernization** - Otomatis modernize repository sources untuk Debian 13

## 💻 Persyaratan Sistem

- **OS**: Debian 12 Bookworm atau Debian 13 Trixie (minimal)
- **Architecture**: AMD64/x86_64
- **RAM**: Minimal 4GB (rekomendasi 8GB+)
- **Storage**: Minimal 32GB (rekomendasi 100GB+)
- **Network**: Koneksi internet untuk download packages
- **Access**: Root access (sudo)

## 🚀 Quick Start

### Step 1: Download dan Jalankan Script Part 1

```bash
wget https://raw.githubusercontent.com/iam-rizz/proxmox-nat-installer/main/install.sh
chmod +x install.sh
sudo ./install.sh
```

Script ini akan:
- Update sistem
- Modernize repository sources ke format deb822 (untuk Debian 13)
- Tambah repository Proxmox VE (format legacy untuk Debian 12, deb822 untuk Debian 13)
- Download dan verify GPG key
- Install Proxmox VE kernel
- Konfigurasi /etc/hosts sesuai best practice Proxmox
- Setup script part 2 untuk auto-run setelah reboot menggunakan .bashrc

### Step 2: Reboot Sistem

```bash
sudo systemctl reboot
```

### Step 3: Script Part 2 Berjalan Otomatis

Setelah reboot, script part 2 akan otomatis berjalan via .bashrc dan:
- Install Proxmox VE packages
- Remove Debian kernel
- Update GRUB
- Remove os-prober
- **Setup Custom MOTD** untuk Proxmox VE
- Cleanup .bashrc entry dan temporary files

### Alternatif: Jalankan Script Part 2 Manual

Jika script part 2 tidak berjalan otomatis, jalankan manual:

```bash
sudo ./install_proxmox2.sh
```

## 🏗️ Post-Installation

1. **Akses Web Interface**
   - Buka browser dan akses: `https://IP_ADDRESS:8006`
   - Login dengan username: `root` dan password root sistem

2. **Setup Network Bridge**
   - Di web interface, buat Linux Bridge `vmbr0`
   - Tambah network interface pertama ke bridge
   - Atau gunakan script: `COMING SOON`

3. **Upload Subscription Key (Opsional)**
   - Jika punya subscription, upload key di web interface
   - Remove no-subscription repository:
     - Untuk Debian 12: `sudo rm /etc/apt/sources.list.d/pve-install-repo.list`
     - Untuk Debian 13: `sudo rm /etc/apt/sources.list.d/pve-install-repo.sources`

## 📊 Custom MOTD (Message of the Day)

Script part 2 akan otomatis setup custom MOTD yang menampilkan informasi sistem Proxmox VE lengkap setiap kali login:

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

### Fitur MOTD:
- ✅ **Auto-update** setiap 5 menit
- ✅ **Informasi sistem real-time**
- ✅ **Status Proxmox VE** (version, jumlah VM, container)
- ✅ **Monitoring resource** (CPU, RAM, Disk)
- ✅ **Quick commands** untuk admin
- ✅ **Disable MOTD Debian default**
- ✅ **Service Status Monitoring** (pve-cluster, pvedaemon, pveproxy, pvestatd)
- ✅ **Network Information** dengan IP address real-time

## 📋 TODO List

### 🔧 **Fase 1: Infrastruktur Inti**
- [x] **Script Instalasi**
  - [x] Instalasi Proxmox VE otomatis
  - [x] Implementasi MOTD kustom
  - [x] Penanganan error dan logging
  - [ ] Dukungan multi-distribusi (Ubuntu, CentOS)
  - [ ] Mode instalasi tanpa pengawasan

- [x] **Konfigurasi Bridge NAT**
  - [x] Setup bridge NAT otomatis
  - [ ] Konfigurasi server DHCP
  - [x] IP forwarding dan masquerading
  - [ ] Otomatisasi aturan firewall
  - [ ] Kebijakan isolasi jaringan

### 🌐 **Fase 2: Manajemen Jaringan**
- [ ] **Server API untuk iptables NAT**
  - [ ] Pengembangan REST API (Node.js/Python)
  - [ ] Manajemen aturan iptables NAT
  - [ ] Autentikasi dan otorisasi
  - [ ] Pembatasan kecepatan dan keamanan
  - [ ] Dokumentasi API (Swagger/OpenAPI)

- [ ] **Alat Port Forwarding**
  - [ ] Antarmuka manajemen port berbasis web
  - [ ] Sistem routing berbasis domain
  - [ ] Manajemen sertifikat SSL/TLS
  - [ ] Konfigurasi load balancing
  - [ ] Monitoring kesehatan dan failover

### 📊 **Fase 3: Monitoring Sistem**
- [ ] **Monitoring Resource**
  - [ ] Pelacakan penggunaan CPU, RAM, Disk
  - [ ] Monitoring bandwidth jaringan
  - [ ] Penggunaan resource VM dan container
  - [ ] Metrik performa storage
  - [ ] Alert dan notifikasi real-time

- [ ] **Manajemen Log**
  - [ ] Pengumpulan log terpusat
  - [ ] Rotasi dan retensi log
  - [ ] Deteksi pola error
  - [ ] Monitoring kejadian keamanan
  - [ ] Analisis bottleneck performa

- [ ] **Pemeriksaan Kesehatan**
  - [ ] Monitoring status layanan
  - [ ] Tes konektivitas jaringan
  - [ ] Verifikasi backup
  - [ ] Alert kedaluwarsa sertifikat
  - [ ] Notifikasi update sistem

## 🔧 Troubleshooting

### Cek Versi Debian yang Terdeteksi
```bash
grep PRETTY_NAME /etc/os-release
cat /home/debian_version.conf
```

### Network tidak berfungsi
- Cek konfigurasi `/etc/hosts`
- Pastikan hostname bisa di-resolve ke IP address:
  ```bash
  hostname --ip-address
  ```

### Repository Issues
- Untuk Debian 12: Repository menggunakan format legacy (.list)
- Untuk Debian 13: Repository menggunakan format deb822 (.sources)
- Script otomatis menjalankan `apt modernize-sources` untuk Debian 13
- Cek repository yang terinstall:
  ```bash
  ls -la /etc/apt/sources.list.d/pve*
  ```
- Manual modernize (khusus Debian 13):
  ```bash
  sudo apt modernize-sources
  ```

### DNS bermasalah
- Jangan install package `resolvconf` atau `rdnssd`
- Proxmox VE mengelola DNS sendiri

### Script Part 2 tidak berjalan otomatis
```bash
tail -20 /root/.bashrc
ls -la /home/install_proxmox2.sh
sudo /home/install_proxmox2.sh
```

### MOTD tidak muncul
```bash
sudo /usr/local/bin/pve-motd.sh
crontab -l | grep pve-motd
sudo systemctl restart update-motd
```

### Log Instalasi
Untuk melihat log instalasi:
```bash
tail -20 /root/.bashrc
ls -la /home/install_proxmox2.sh
journalctl -u pveproxy
journalctl -u pvedaemon
```

## 🛡️ Script Features

- ✅ System validation (Debian 12/13, root access)
- ✅ Auto-detect Debian version and configure appropriate repository format
- ✅ Auto-run part 2 script after reboot using .bashrc
- ✅ Proper /etc/hosts configuration following Proxmox best practices
- ✅ Error handling and logging
- ✅ Automatic cleanup of .bashrc entry and temporary files
- ✅ Colored messages for easy reading
- ✅ Custom MOTD with complete Proxmox VE information
- ✅ Service Status Monitoring for Proxmox VE services
- ✅ **Auto-modernize sources**: Otomatis jalankan `apt modernize-sources` untuk Debian 13
- ✅ Version-specific kernel removal (6.1.x for Debian 12, 6.12.x for Debian 13)

## 🤝 Contributing

Kami menyambut kontribusi dari komunitas! Silakan:

1. Fork repository ini
2. Buat feature branch (`git checkout -b feature/FiturMenakjubkan`)
3. Commit perubahan Anda (`git commit -m 'Tambah Fitur Menakjubkan'`)
4. Push ke branch (`git push origin feature/FiturMenakjubkan`)
5. Buka Pull Request

### 📝 Panduan
- Ikuti standar coding yang ada
- Tambah test untuk fitur baru
- Update dokumentasi jika diperlukan
- Pastikan semua test berhasil

Lihat [CONTRIBUTING.md](CONTRIBUTING.md) untuk detail lebih lanjut.

## 📄 License

Project ini dilisensikan di bawah **MIT License** - lihat file [LICENSE](LICENSE) untuk detail.

## 🙏 Acknowledgments

- [Proxmox VE Team](https://www.proxmox.com/) untuk software yang luar biasa
- [Debian Project](https://www.debian.org/) untuk sistem operasi yang stabil
- Komunitas open source untuk inspirasi dan dukungan

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/iam-rizz/proxmox-nat-installer/issues)

## 🌐 Language Support

- 🇮🇩 **Indonesian**: [README.md](README.md) | [CONTRIBUTING.md](CONTRIBUTING.md)
- 🇺🇸 **English**: [README_EN.md](README_EN.md) | [CONTRIBUTING_EN.md](CONTRIBUTING_EN.md)

---

**Made with ❤️ by [iam-rizz](https://github.com/iam-rizz)** 