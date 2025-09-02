# NASM Installation Guide

## Linux

### Method 1: Manual Installation

1. **Download NASM:**
    - Visit the [NASM releases page](https://www.nasm.us/pub/nasm/releasebuilds/).
    - Download the latest Linux source archive (e.g., `nasm-2.16.03.tar.gz`).

2. **Extract the Archive:**
    ```sh
    tar -xzf nasm-2.16.03.tar.gz
    cd nasm-2.16.03
    ```

3. **Build and Install:**
    ```sh
    ./configure
    make
    sudo make install
    ```

4. **Verify Installation:**
    ```sh
    nasm --version
    ```

---

### Method 2: Install via Package Manager

1. **Install NASM:**
    - For Ubuntu/Debian:
      ```sh
      sudo apt update
      sudo apt install nasm
      ```

2. **Verify Installation:**
    ```sh
    nasm --version
    ```
