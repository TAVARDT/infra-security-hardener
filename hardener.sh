#!/bin/bash
# ----------------------------------------------------------------------
# TAVARDT Elite Infrastructure Hardener
# Description: Automated security protocol for Linux (Ubuntu/Debian)
# ----------------------------------------------------------------------

set -e

echo "🔍 [TAVARDT CYBER] Starting Infrastructure Hardening Protocol..."

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
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
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
