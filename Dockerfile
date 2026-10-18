# BotPanel — Railway-ready Dockerfile
FROM node:20-slim

# git (repo clone), ffmpeg + build tools (aksar bots ko chahiye hota hai)
# ca-certificates lazmi hai warna git clone HTTPS verify nahi kar pata
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates ffmpeg python3 make g++ \
  && rm -rf /var/lib/apt/lists/* \
  && corepack enable

WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY . .

# Railway /data par Volume mount karega — wahan bots, sessions aur DB rahenge
ENV DATA_DIR=/data

# Railway khud PORT deta hai
CMD ["node", "server.js"]
