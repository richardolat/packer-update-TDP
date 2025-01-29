# packer-update-TDP

# Logging, Auditing, and Privilege Management Script

## Overview
This project provides a shell script (`001-critical-standards.sh`) designed to enable logging and auditing using `auditd` and enforce privilege limitations using `sudo` on both Debian-based and RedHat-based systems. The script adheres to CSI (Critical Security Infrastructure) standards and ensures consistent configurations for enhanced system security.

The testing for this project was carried out on an **Ubuntu virtual server created on AWS**.

---

## Features

### Logging and Auditing
- Installs and configures `auditd` for logging critical events.
- Ensures the `auditd` service starts on boot.
- Validates that `auditd` is correctly logging significant events.
- Logs actions and errors during execution.
- Handles exit codes to ensure proper error handling.

### Limiting User Privileges
- Configures `sudo` to limit root access and enforce the principle of least privilege.
- Ensures only authorized users have `sudo` access.
- Validates `sudo` configurations to prevent privilege escalation.
- Logs actions and errors during execution.
- Handles exit codes to ensure proper error handling.

---

## Prerequisites

### AWS Ubuntu Virtual Server Setup
1. **Create an AWS Account**:
   - Log in to [AWS Management Console](https://aws.amazon.com/).

2. **Launch an EC2 Instance**:
   - Navigate to the EC2 service.
   - Click on **Launch Instances**.
   - Choose an Amazon Machine Image (AMI): Select **Ubuntu Server 22.04 LTS** (or another preferred version).
   - Choose an instance type: Select a free-tier eligible type, such as `t2.micro`.
   - Configure the instance:
     - Add a key pair for secure SSH access.
     - Configure security groups to allow SSH (port 22) access.
   - Launch the instance.

3. **Connect to the Instance**:
   - Use your SSH client to connect:
     ```bash
     ssh -i <your-key-file.pem> ubuntu@<your-instance-public-IP>
     ```

4. **Update the System**:
   - Update and upgrade packages:
     ```bash
     sudo apt update && sudo apt upgrade -y
     ```

---

## Script Execution

### Steps to Use the Script
1. **Clone the Repository**:
   - Clone the GitHub repository containing the script:
     ```bash
     git clone <repository-url>
     cd <repository-directory>
     ```

2. **Make the Script Executable**:
   - Grant execute permissions:
     ```bash
     chmod +x 001-critical-standards.sh
     ```

3. **Run the Script**:
   - Execute the script as root or with `sudo`:
     ```bash
     sudo ./001-critical-standards.sh
     ```

### Post-Execution Validation
1. **Auditd Validation**:
   - Verify that `auditd` is running:
     ```bash
     systemctl status auditd
     ```
   - Check logged events:
     ```bash
     sudo auditctl -l
     ```

2. **Sudo Configuration Validation**:
   - Ensure the `authorized_user` has sudo access:
     ```bash
     sudo -l -U authorized_user
     ```
   - Validate the `sudo` configuration:
     ```bash
     sudo visudo -c
     ```

3. **Logs**:
   - Review the execution logs at `/var/log/001-critical-standards.log`:
     ```bash
     cat /var/log/001-critical-standards.log
     ```

---

## Files
- **001-critical-standards.sh**: The main script for enabling logging, auditing, and limiting user privileges.
- **/var/log/001-critical-standards.log**: Log file for actions and errors during script execution.

---

## Troubleshooting
1. **Permissions Issues**:
   - Ensure you are running the script with `sudo` privileges.

2. **Unknown User**:
   - Create the `authorized_user` before running the script:
     ```bash
     sudo adduser authorized_user
     sudo usermod -aG sudo authorized_user
     ```

3. **Unsupported Systems**:
   - This script is tested on Debian-based (Ubuntu) and RedHat-based (CentOS/RHEL) systems.
   - For other distributions, additional modifications may be required.

---

## Contribution
This project is a collaboration between **RICHARD OLATUNDE** and other DevOps engineers. ARK's contributions are tracked under **#TDP-249-TIME-DELTA-PROJECT**. Contributions, improvements, and issues are welcome via pull requests.

---

## License
This project is licensed under the [MIT License](LICENSE).

