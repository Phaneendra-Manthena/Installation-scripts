#!/bin/bash

# Check if user is root
if [ $(id -u) -ne 0 ]; then
  echo "You must be root to run this script."
  exit 1
fi

# Prompt for user name
read -p "Enter user name: " username

# Prompt for password
read -s -p "Enter password: " password

# Confirm password
read -s -p "Confirm password: " password_confirm

# Check if passwords match
if [ "$password" != "$password_confirm" ]; then
  echo "Passwords do not match."
  exit 1
fi

# Create user
useradd -m -p "$password" $username

# Give root privileges
echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Change password authentication to yes
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# Restart SSH service
service ssh restart

echo "User $username has been created with root privileges."
