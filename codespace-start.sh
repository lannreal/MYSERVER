#!/bin/bash

echo "========================================="
echo "   🚀 MEMULAI AM GENERATOR DI CODESPACES"
echo "========================================="

# Update package list and install dependencies if not exist
if ! command -v Xvfb &> /dev/null || ! command -v google-chrome-stable &> /dev/null && ! command -v chromium &> /dev/null; then
    echo "⚠️  Menginstal Google Chrome dan Xvfb di Codespaces..."
    sudo apt-get update -y
    sudo apt-get install -y xvfb x11-xserver-utils chromium-browser chromium
fi

echo "✅ Dependensi siap."

# Mengecek dan mematikan Xvfb lama
pkill Xvfb 2>/dev/null
pkill chrome 2>/dev/null
pkill chromium 2>/dev/null

echo "👻 Menjalankan Layar Siluman (Xvfb)..."
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &
export DISPLAY=:99

sleep 2

echo "📦 Menginstal package Node.js (jika belum)..."
npm install

echo "🤖 Menjalankan Bot Automation..."
node app.js --api

echo "🛑 Bot berhenti."
