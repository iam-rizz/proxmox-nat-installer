# Proxmox VE NAT Network Project

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Debian](https://img.shields.io/badge/Debian-12%20Bookworm-red.svg)](https://www.debian.org/)
[![Proxmox VE](https://img.shields.io/badge/Proxmox%20VE-8.x-orange.svg)](https://www.proxmox.com/)
[![GitHub Views](https://komarev.com/ghpvc/?username=iam-rizz&repo=proxmox-nat-installer&color=blue&style=flat-square)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Stars](https://img.shields.io/github/stars/iam-rizz/proxmox-nat-installer?style=social)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Forks](https://img.shields.io/github/forks/iam-rizz/proxmox-nat-installer?style=social)](https://github.com/iam-rizz/proxmox-nat-installer)
[![GitHub Issues](https://img.shields.io/github/issues/iam-rizz/proxmox-nat-installer)](https://github.com/iam-rizz/proxmox-nat-installer/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/iam-rizz/proxmox-nat-installer)](https://github.com/iam-rizz/proxmox-nat-installer/pulls)

**Open Source Project** untuk menginstall dan mengkonfigurasi Proxmox Virtual Environment (PVE) dengan jaringan NAT untuk Virtual Machines (VMs) dan Containers.

## 📋 Daftar Isi

- [Fitur](#-fitur)
- [Persyaratan Sistem](#-persyaratan-sistem)
- [File Script](#-file-script)
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

## ✨ Fitur

- 🚀 **Instalasi Otomatis** - Script 2 tahap untuk instalasi Proxmox VE
- 🔄 **Auto-Execution** - Script part 2 berjalan otomatis setelah reboot via .bashrc
- 🎨 **Custom MOTD** - Message of the Day profesional dengan info sistem lengkap
- 🛡️ **Error Handling** - Penanganan error dan logging yang baik
- 🧹 **Auto-Cleanup** - Pembersihan otomatis file temporary dan .bashrc entry
- 🌐 **NAT Network** - Setup jaringan NAT untuk VMs dan containers
- 📊 **System Monitoring** - Monitoring resource dan status Proxmox VE
- 🔧 **Troubleshooting** - Panduan troubleshooting lengkap

## 💻 Persyaratan Sistem

- **OS**: Debian 12 Bookworm (minimal)
- **Architecture**: AMD64/x86_64
- **RAM**: Minimal 4GB (rekomendasi 8GB+)
- **Storage**: Minimal 32GB (rekomendasi 100GB+)
- **Network**: Koneksi internet untuk download packages
- **Access**: Root access (sudo)

## 🚀 Quick Start

### Step 1: Download dan Jalankan Script Part 1

```bash
COMING SOON
```

Script ini akan:
- Update sistem
- Tambah repository Proxmox VE
- Download dan verify GPG key
- Install Proxmox VE kernel
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
COMING SOON
```

## 🏗️ Post-Installation

1. **Akses Web Interface**
   - Buka browser dan akses: `https://IP_ADDRESS:8006`
   - Login dengan username: `root` dan password root sistem

2. **Setup Network Bridge**
   - Di web interface, buat Linux Bridge `vmbr0`
   - Tambah network interface pertama ke bridge

3. **Upload Subscription Key (Opsional)**
   - Jika punya subscription, upload key di web interface
   - Remove no-subscription repository:
     ```bash
     sudo rm /etc/apt/sources.list.d/pve-install-repo.list
     ```

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

## 📋 TODO List

### 🔧 **Fase 1: Infrastruktur Inti**
- [ ] **Script Instalasi**
  - [ ] Instalasi Proxmox VE otomatis
  - [ ] Implementasi MOTD kustom
  - [ ] Penanganan error dan logging
  - [ ] Dukungan multi-distribusi (Ubuntu, CentOS)
  - [ ] Mode instalasi tanpa pengawasan

- [ ] **Konfigurasi Bridge NAT**
  - [ ] Setup bridge NAT otomatis
  - [ ] Konfigurasi server DHCP
  - [ ] IP forwarding dan masquerading
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