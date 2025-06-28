# Contributing to Proxmox VE NAT Network Project

Thank you for your interest in contributing to this project! We welcome all types of contributions, whether it's bug reports, feature requests, documentation improvements, or code contributions.

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

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/). By participating, you are expected to uphold this code of ethics.

## 🚀 How Can I Contribute?

### Reporting Bugs

- Use the provided bug report template
- Describe steps to reproduce the bug
- Include system information (OS, version, etc.)
- Attach error logs if available

### Suggesting Enhancements

- Describe the desired feature in detail
- Provide use cases and benefits
- Consider impact on performance and security

### Code Contributions

- Fork the repository
- Create a feature branch
- Implement changes
- Add tests
- Submit pull request

## 🛠️ Development Setup

### Prerequisites

- Debian 12 Bookworm (for testing)
- Git
- Bash shell
- Root access (for testing installer)

### Local Development

```bash
# Clone repository
git clone https://github.com/iam-rizz/proxmox-nat-installer.git
cd proxmox-nat-installer

# Make scripts executable
chmod +x *.sh

# Test scripts (in safe environment)
./make_executable.sh
```

### Testing Environment

For testing installer scripts, use:
- Virtual machine with Debian 12
- Docker container with Debian 12
- Cloud instance (VPS) with Debian 12

## 📝 Coding Standards

### Bash Scripts

- Use `#!/bin/bash` shebang
- Add error handling with `set -e`
- Use functions for modularity
- Add clear comments
- Use meaningful variable names

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

- Use Markdown format
- Add emojis for readability
- Clear structure with headings
- Runnable code examples

### Commit Messages

Use conventional commits format:

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

1. **Fork repository** and clone to local
2. **Create feature branch**: `git checkout -b feature/your-feature`
3. **Implement changes** with coding standards
4. **Test changes** in appropriate environment
5. **Update documentation** if needed
6. **Commit changes** with conventional commits

### Pull Request Guidelines

1. **Title**: Describe changes briefly
2. **Description**: 
   - Explain the problem being solved
   - Include screenshots if UI changes
   - Reference issue if applicable
3. **Checklist**: Ensure all items are completed
4. **Tests**: Ensure all tests pass

### Review Process

- Maintainer will review PR within 48 hours
- Address feedback and suggestions
- Maintainer will merge after approval

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

- Update README.md for major changes
- Add inline comments in scripts
- Create separate documentation files for complex features
- Use clear and concise language

### Documentation Standards

- Use Markdown format
- Consistent structure
- Runnable code examples
- Screenshots for UI features
- Links to external references

## 🏷️ Labels

We use labels to categorize issues and PRs:

- `bug`: Bug reports
- `enhancement`: Feature requests
- `documentation`: Documentation improvements
- `good first issue`: Good for newcomers
- `help wanted`: Looking for contributors
- `priority: high`: High priority items
- `priority: medium`: Medium priority items
- `priority: low`: Low priority items

## 🎯 Getting Help

If you need help:

1. **Check existing issues** for existing solutions
2. **Search documentation** for relevant information
3. **Create new issue** if problem doesn't exist

## 🙏 Recognition

Contributors will be recognized with:

- Credit in README.md
- Contributor badge in profile
- Mention in release notes
- Special thanks in documentation

## 🌐 Language Support

This project supports both Indonesian and English:

- **Indonesian**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **English**: [CONTRIBUTING_EN.md](CONTRIBUTING_EN.md)

Choose the language you're most comfortable with for contributions.

---

**Thank you for contributing to this project!** 🚀 