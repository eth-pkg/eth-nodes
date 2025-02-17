# System Architecture

## Overview

The system uses two main components to create reproducible Debian packages:

1. **debcrafter** ([https://github.com/Kixunil/debcrafter](https://github.com/Kixunil/debcrafter)): Generates reproducible Debian directories from specification files
2. **pkg-builder** ([https://github.com/eth-pkg/pkg-builder](https://github.com/eth-pkg/pkg-builder)): Creates minimal build environments and manages package dependencies

## Key Components

### debcrafter
- Generates Debian directories from .sss and .sps files
- Supports reproducible builds
- Enables modular package creation
- Manages package relationships

### pkg-builder
- Extends debcrafter functionality
- Provides package pinning
- Implements hash verification
- Supports multiple programming languages:
  - C
  - .NET
  - Java
  - Rust
  - Go
  - Nim
- Supports multiple Linux backends:
  - Noble Numbat
  - Jammy
  - Debian 12

## Advantages

1. **Monorepo Benefits**
   - Clear view of shipped packages
   - Simplified version management
   - Easy relationship tracking
   - Centralized update management

2. **Modular Design**
   - Independent package management
   - Simplified dependency handling
   - Efficient patching system

3. **Build Verification**
   - Multiple verification methods
   - Reproducible environments
   - Consistent tooling