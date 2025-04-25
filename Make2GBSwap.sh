#!/bin/bash

# Define swap file size and location
SWAPFILE="/swapfile"
SWAPSIZE=2048  # Size in MB (2GB)

# Check if swap file already exists
if [ -f "$SWAPFILE" ]; then
    echo "Swap file already exists at $SWAPFILE"
    exit 1
fi

# Create the swap file
echo "Creating a $SWAPSIZE MB swap file at $SWAPFILE..."
sudo dd if=/dev/zero of=$SWAPFILE bs=1M count=$SWAPSIZE status=progress

# Set the correct permissions
echo "Setting correct permissions for the swap file..."
sudo chmod 600 $SWAPFILE

# Set up the swap space
echo "Setting up swap space..."
sudo mkswap $SWAPFILE

# Enable the swap
echo "Enabling the swap file..."
sudo swapon $SWAPFILE

# Verify swap is active
echo "Verifying swap status..."
sudo swapon --show

# Make the swap file permanent by adding it to /etc/fstab
echo "Making the swap file permanent..."
echo "$SWAPFILE none swap sw 0 0" | sudo tee -a /etc/fstab

echo "Swap file creation and setup completed successfully!"
