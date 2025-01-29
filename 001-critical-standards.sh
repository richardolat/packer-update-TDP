#!/bin/bash

# Function to log actions and errors
echo_log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> /var/log/001-critical-standards.log
}

# Function to enable logging and auditing
enable_logging_auditing() {
  echo_log "Starting logging and auditing configuration..."

  if [ -f /etc/debian_version ]; then
    # Install auditd on Debian-based systems
    echo_log "Detected Debian-based system. Installing auditd..."
    apt-get update && apt-get install auditd -y
  elif [ -f /etc/redhat-release ]; then
    # Install auditd on RedHat-based systems
    echo_log "Detected RedHat-based system. Installing auditd..."
    yum install audit -y
  else
    echo_log "Unsupported operating system. Exiting..."
    exit 1
  fi

  # Enable and start auditd service
  echo_log "Enabling and starting auditd service..."
  systemctl enable auditd && systemctl start auditd

  # Validate auditd is logging appropriate events
  echo_log "Validating auditd configuration..."
  auditctl -l &>> /var/log/001-critical-standards.log

  if [ $? -ne 0 ]; then
    echo_log "Error: auditd validation failed. Exiting..."
    exit 1
  fi

  echo_log "Logging and auditing configuration completed successfully."
}

# Function to limit user privileges
limit_user_privileges() {
  echo_log "Starting user privilege limitation..."

  # Configure sudoers file to limit root access
  echo_log "Configuring sudoers file..."
  echo "Defaults rootpw" >> /etc/sudoers
  echo "authorized_user ALL=(ALL) ALL" > /etc/sudoers.d/authorized_user
  chmod 440 /etc/sudoers.d/authorized_user

  # Ensure only authorized users have sudo access
  echo_log "Restricting sudo access to authorized users..."
  usermod -aG sudo authorized_user

  # Validate sudo configuration
  echo_log "Validating sudo configuration..."
  visudo -c &>> /var/log/001-critical-standards.log

  if [ $? -ne 0 ]; then
    echo_log "Error: sudo configuration validation failed. Exiting..."
    exit 1
  fi

  echo_log "User privilege limitation completed successfully."
}

# Main script execution
echo_log "Starting 001-critical-standards.sh execution..."

enable_logging_auditing
if [ $? -ne 0 ]; then
  echo_log "Failed to enable logging and auditing. Exiting..."
  exit 1
fi

limit_user_privileges
if [ $? -ne 0 ]; then
  echo_log "Failed to limit user privileges. Exiting..."
  exit 1
fi

echo_log "Script executed successfully."

