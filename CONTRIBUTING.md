# Contributing to Proxmox VE NAT Network Project

Terima kasih atas minat Anda untuk berkontribusi pada project ini! Kami menyambut semua jenis kontribusi, baik itu bug reports, feature requests, documentation improvements, atau code contributions.

## 🌐 Dukungan Bahasa

Project ini mendukung dua bahasa untuk dokumentasi:

- **Bahasa Indonesia**: [CONTRIBUTING.md](CONTRIBUTING.md) (halaman ini)
- **English**: [CONTRIBUTING_EN.md](CONTRIBUTING_EN.md)

Pilih bahasa yang paling nyaman untuk Anda gunakan dalam berkontribusi.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Documentation](#documentation)

## 🤝 Code of Conduct

Project ini mengikuti [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/). Dengan berpartisipasi, Anda diharapkan untuk mematuhi kode etik ini.

## 🚀 How Can I Contribute?

### Reporting Bugs

- Gunakan template bug report yang disediakan
- Jelaskan langkah-langkah untuk mereproduksi bug
- Sertakan informasi sistem (OS, version, dll)
- Lampirkan log error jika ada

### Suggesting Enhancements

- Jelaskan fitur yang diinginkan secara detail
- Berikan use case dan manfaatnya
- Pertimbangkan dampak pada performa dan keamanan

### Code Contributions

- Fork repository
- Buat feature branch
- Implementasikan perubahan
- Tambahkan tests
- Submit pull request

## 🛠️ Development Setup

### Prerequisites

- Debian 12 Bookworm (untuk testing)
- Git
- Bash shell
- Root access (untuk testing installer)

### Local Development

```bash
# Clone repository
git clone https://github.com/iam-rizz/proxmox-nat-installer.git
cd proxmox-nat-installer

# Make scripts executable
chmod +x *.sh

# Test scripts (dalam environment yang aman)
./make_executable.sh
```

### Testing Environment

Untuk testing installer scripts, gunakan:
- Virtual machine dengan Debian 12
- Docker container dengan Debian 12
- Cloud instance (VPS) dengan Debian 12

## 📝 Coding Standards

### Bash Scripts

- Gunakan `#!/bin/bash` shebang
- Tambahkan error handling dengan `set -e`
- Gunakan fungsi untuk modularitas
- Tambahkan komentar yang jelas
- Gunakan meaningful variable names

```bash
#!/bin/bash

# Script description
# Author: Your Name
# Date: YYYY-MM-DD

set -e  # Exit on any error

# Function to display colored output
print_status() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

# Main script logic
main() {
    print_status "Starting process..."
    # Your code here
    print_success "Process completed!"
}

main "$@"
```

### Documentation

- Gunakan Markdown format
- Tambahkan emoji untuk readability
- Struktur yang jelas dengan headings
- Contoh kode yang dapat dijalankan

### Commit Messages

Gunakan format conventional commits:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(installer): add custom MOTD support
fix(network): resolve bridge configuration issue
docs(readme): update installation instructions
```

## 🔄 Pull Request Process

### Before Submitting

1. **Fork repository** dan clone ke local
2. **Buat feature branch**: `git checkout -b feature/your-feature`
3. **Implementasikan perubahan** dengan coding standards
4. **Test perubahan** di environment yang sesuai
5. **Update dokumentasi** jika diperlukan
6. **Commit changes** dengan conventional commits

### Pull Request Guidelines

1. **Title**: Jelaskan perubahan secara singkat
2. **Description**: 
   - Jelaskan masalah yang diselesaikan
   - Sertakan screenshots jika UI changes
   - Referensi issue jika ada
3. **Checklist**: Pastikan semua item terpenuhi
4. **Tests**: Pastikan semua tests pass

### Review Process

- Maintainer akan review PR dalam 48 jam
- Address feedback dan suggestions
- Maintainer akan merge setelah approval

## 🐛 Reporting Bugs

### Bug Report Template

```markdown
## Bug Description
Brief description of the bug

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- OS: [e.g., Debian 12 Bookworm]
- Proxmox VE Version: [e.g., 8.1.4]
- Script Version: [e.g., v1.0.0]

## Additional Information
- Screenshots (if applicable)
- Log files
- Error messages
```

## 💡 Suggesting Enhancements

### Enhancement Request Template

```markdown
## Enhancement Description
Detailed description of the requested feature

## Use Case
How this feature would be used

## Benefits
What benefits this feature would provide

## Implementation Ideas
Any ideas for implementation (optional)

## Priority
High/Medium/Low
```

## 📚 Documentation

### Contributing to Documentation

- Update README.md untuk perubahan besar
- Tambahkan inline comments di scripts
- Buat separate documentation files untuk fitur kompleks
- Gunakan clear and concise language

### Documentation Standards

- Gunakan Markdown format
- Struktur yang konsisten
- Contoh kode yang dapat dijalankan
- Screenshots untuk UI features
- Link ke referensi eksternal

## 🏷️ Labels

Kami menggunakan labels untuk mengkategorikan issues dan PRs:

- `bug`: Bug reports
- `enhancement`: Feature requests
- `documentation`: Documentation improvements
- `good first issue`: Good for newcomers
- `help wanted`: Looking for contributors
- `priority: high`: High priority items
- `priority: medium`: Medium priority items
- `priority: low`: Low priority items

## 🎯 Getting Help

Jika Anda membutuhkan bantuan:

1. **Check existing issues** untuk solusi yang sudah ada
2. **Search documentation** untuk informasi yang relevan
3. **Create new issue** jika masalah belum ada

## 🙏 Recognition

Kontributor akan diakui dengan:

- Credit di README.md
- Contributor badge di profile
- Mention di release notes
- Special thanks di documentation

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/iam-rizz/proxmox-nat-installer/issues)
- **Discussions**: [GitHub Discussions](https://github.com/iam-rizz/proxmox-nat-installer/discussions)
- **Wiki**: [GitHub Wiki](https://github.com/iam-rizz/proxmox-nat-installer/wiki)

---

**Terima kasih atas kontribusi Anda untuk project ini!** 🚀 