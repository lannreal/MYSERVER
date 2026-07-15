#!/bin/bash

echo "========================================="
echo "   🚀 MEMULAI AM GENERATOR DI CODESPACES"
echo "========================================="

if ! command -v Xvfb &> /dev/null || ! command -v google-chrome-stable &> /dev/null; then
    echo "⚠️  Menginstal Google Chrome Stable dan Xvfb di Codespaces (tanpa Snap)..."
    sudo apt-get update -y
    sudo apt-get install -y xvfb x11-xserver-utils wget gnupg
    
    # Hapus chromium-browser bodong kalau ada
    sudo apt-get remove -y chromium-browser chromium
    
    # Install Google Chrome asli dari source
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list
    sudo apt-get update -y
    sudo apt-get install -y google-chrome-stable
fi

echo "✅ Dependensi siap."

# Mengecek dan mematikan Xvfb lama
pkill Xvfb 2>/dev/null
pkill chrome 2>/dev/null

echo "👻 Menjalankan Layar Siluman (Xvfb)..."
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &
export DISPLAY=:99

sleep 2

echo "📦 Menginstal package Node.js (jika belum)..."
npm install

echo "🤖 Menjalankan Bot Automation..."
node app.js --api

echo "🛑 Bot berhenti."
