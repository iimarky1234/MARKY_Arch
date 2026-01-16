#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)."
   exit 1
fi

# Prompt for the new username
read -p "Enter the username of the new user: " username

# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "Error: User '$username' already exists."
    exit 1
fi

# Create the user with a home directory and bash as the default shell
useradd -m -s /bin/bash "$username"

if [ $? -eq 0 ]; then
    echo "User '$username' created successfully."
else
    echo "Failed to create user '$username'."
    exit 1
fi

# Set the password for the new user
echo "Setting password for '$username':"
passwd "$username"

# Ask if the user should be added to the sudo group
read -p "Do you want to grant sudo privileges to '$username'? (y/n): " grant_sudo

if [[ "$grant_sudo" =~ ^[Yy]$ ]]; then
    # Detect the correct group (sudo for Debian/Ubuntu, wheel for RHEL/CentOS)
    if grep -q "^sudo:" /etc/group; then
        SUDO_GROUP="sudo"
    elif grep -q "^wheel:" /etc/group; then
        SUDO_GROUP="wheel"
    else
        echo "Could not find a sudo or wheel group. Skipping sudo assignment."
    fi

    if [ -n "$SUDO_GROUP" ]; then
        usermod -aG "$SUDO_GROUP" "$username"
        echo "User '$username' has been added to the $SUDO_GROUP group."
    fi
else
    echo "Sudo privileges not granted."
fi

echo "Setup complete for user '$username'."

su $username
