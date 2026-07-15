# Gunakan base image Node.js 20 Debian Bookworm yang stabil
FROM node:20-bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=3000
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:99
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# Install Python 3, pip, dependensi X11/headless, dan Google Chrome Stable untuk DrissionPage
RUN apt-get update && apt-get install -y --no-install-recommends \
    procps \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    gnupg \
    ca-certificates \
    libnss3 \
    libatk1.0-0 \
    libasound2 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcups2 \
    fonts-liberation \
    xdg-utils \
    xvfb \
    x11-utils \
    x11-xserver-utils \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg \
    && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Setup Node.js dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev

# Copy seluruh file aplikasi ke dalam container
COPY . .

# Pastikan izin akses folder chrome_profile untuk penyimpanan profil headless
RUN mkdir -p chrome_profile && chmod -R 777 chrome_profile

# Expose HTTP Port
EXPOSE 3000

# Skrip startup: jalankan Xvfb (virtual display) sebelum Node server
# Xvfb memungkinkan Chrome berjalan dengan display virtual (non-headless) sehingga
# Cloudflare Turnstile bisa diselesaikan secara otomatis!
RUN echo '#!/bin/bash\nXvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &\necho "[XVFB] Virtual display :99 started"\nsleep 1\nexec node app.js --api' > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]
