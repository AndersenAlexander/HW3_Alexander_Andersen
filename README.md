# 🐧 Linux Administration - DevOps Tools Installer

This repository contains the solution for **Homework Topic 3** of the Linux Administration course. The project consists of an automated Bash script designed to set up the essential working environment for a DevOps engineer.

## 🚀 Description

The `install_dev_tools.sh` script automates the installation and configuration of development tools on **Ubuntu** and **Debian**-based distributions. The script is smartly designed to be idempotent (it avoids reinstalling packages if they already exist on the system) and fully non-interactive.

### Installed tools:
* **Docker** (latest stable version via the official repository)
* **Docker Compose** (v2 plugin or v1 standalone)
* **Python 3** (version 3.9 or newer) & `pip3`
* **Django** (version >= 4)

## ✨ Key Features
* **Automatic OS Detection:** Dynamically adds the correct Docker repository based on the OS (`ubuntu` or `debian`).
* **Robust Design:** Uses `set -e` to halt execution immediately in case of an error, preventing corrupt installations.
* **Non-Interactive Mode:** Sets `DEBIAN_FRONTEND=noninteractive` to prevent execution blocks caused by `apt-get` prompts (e.g., timezone configuration).
* **Colored Output (UI):** Provides clear and structured visual feedback in the terminal (Info, Success, and Warning messages).
* **Modern Django Installation:** Uses the `--break-system-packages` flag and detects the current user (`$SUDO_USER`) to correctly install Python modules at the user level (PEP 668), even if the script is executed using `sudo`.

## 🛠️ How to Use

1.  Grant execution permissions to the script:
    ```bash
    chmod u+x install_dev_tools.sh
    ```

2.  Run the script in your terminal:
    ```bash
    ./install_dev_tools.sh
    ```
    *Note: You will be prompted for your `sudo` password only once at the beginning of the execution to authenticate the required privileges.*

## 📌 System Requirements
* Operating System: Ubuntu or Debian.
* User with administrator (`sudo`) privileges.
* A stable internet connection.
