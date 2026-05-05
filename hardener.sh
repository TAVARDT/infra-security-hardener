#!/bin/bash
# ----------------------------------------------------------------------
# TAVARDT Elite Infrastructure Hardener
# Description: Automated security protocol for Linux (Ubuntu/Debian)
# ----------------------------------------------------------------------

set -e

echo "🔍 [TAVARDT CYBER] Starting Infrastructure Hardening Protocol..."

# 0. Safety Check: Root and SSH Keys
if [ "$EUID" -ne 0 ]; then 
  echo "🚨 [ERROR] Please run as root (use sudo)."
  exit 1
fi

AUTH_KEYS_FILE="$HOME/.ssh/authorized_keys"
if [ ! -f "$AUTH_KEYS_FILE" ] || [ ! -s "$AUTH_KEYS_FILE" ]; then
  echo "⚠️  [WARNING] No SSH Keys detected in $AUTH_KEYS_FILE."
  echo "🚨 [SAFETY LOCK] Password authentication will NOT be disabled to prevent lockout."
  SKIP_PASSWORD_HARDENING=true
else
  echo "✅ SSH Keys detected. Proceeding with high security mode."
  SKIP_PASSWORD_HARDENING=false
fi

# 1. Update System
echo "📦 Updating OS packages..."
sudo apt-get update && sudo apt-get upgrade -y

# 2. Firewall Configuration (UFW)
echo "🛡️ Configuring Firewall (UFW)..."
sudo apt-get install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
echo "y" | sudo ufw enable

# 3. SSH Hardening
echo "🔐 Hardening SSH Configuration..."
# Disable direct root login (Best practice: login as user and use sudo)
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

if [ "$SKIP_PASSWORD_HARDENING" = false ]; then
  echo "🔒 Disabling password authentication (SSH Keys only)..."
  sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
fi

sudo systemctl restart ssh

# 4. Fail2Ban Installation
echo "🚫 Installing Fail2Ban for Brute Force protection..."
sudo apt-get install fail2ban -y
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# 5. User Audit
echo "👤 Auditing users with sudo access..."
grep '^sudo:.*$' /etc/group | cut -d: -f4

echo ""
echo "✅ [SUCCESS] TAVARDT Elite Hardening Protocol Complete."
echo "📊 Final Score: High. Server is now protected by TAVARDT standards."
echo "🔗 For advanced recovery and ransomware defense, contact: ag.tavardt.com"
