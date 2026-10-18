# 🤖 BotPanel — Apna Khud ka Bot Hosting Server

`server.dmltech.me` jaisa apna panel, jo **Railway par host** hota hai.
Ek dafa deploy karo, phir dashboard se jitne chaho bots add karo —
WhatsApp bots, Telegram bots, Discord bots, ya koi bhi Node/Python bot.

## Ye kaam kaise karta hai

- Panel ek web dashboard hai (login protected).
- **Add Bot** me GitHub repo URL + env variables do → panel repo clone karke
  install karta hai → **Start** dabao, bot chalne lagta hai.
- Har bot alag process me chalta hai. Crash ho to **auto-restart**.
- **Logs** dashboard me, **Redeploy** se `git pull` + reinstall ek click par.
- Sab kuch `/data` (Railway Volume) me rehta hai → redeploy par code,
  WhatsApp sessions aur database **wipe nahi hote**.

## Railway par deploy (5 minute)

1. Is repo ko apne GitHub par push karo.
2. Railway → **New Project** → **Deploy from GitHub repo** → ye repo select karo.
3. Service → **Variables** me ye 2 variables lagao:

   | Variable     | Value              |
   |--------------|--------------------|
   | `PANEL_USER` | apni marzi ka user |
   | `PANEL_PASS` | mazboot password   |

4. Service par right-click (ya `⌘K`) → **Add Volume** → mount path: `/data`
5. Settings → Networking → **Generate Domain** → yehi tumhara panel ka URL hai.
6. Deploy complete → domain kholo, login karo. Ho gaya!

## Bot add karna (misal: Levanter WhatsApp bot)

Dashboard par:
- **Bot ka naam:** `levanter`
- **Repo URL:** `https://github.com/faxitech59-lab/levanter`
- **Branch:** `master`
- **Start command:** `npm run docker` (pm2-runtime wala)
- **Env variables:**
  ```
  SESSION_ID=tumhara_session_id
  DATABASE_URL=/data/database.db
  VPS=true
  AUTO_UPDATE=false
  ```
- **Add Bot** → clone/install ka status dekho → **Start** ▶

> `DATABASE_URL=/data/database.db` is liye taake session keys volume par
> rahen. Har bot ka apna subfolder hota hai, is liye do bots ki DB
> apas me takrayegi nahi — phir bhi alag naam behtar hai
> (misal: `/data/levanter.db`).

## "Free" ke baare me sach

Railway usage-based hai — ye panel **ek hi service** me saare bots
chalata hai, to alag-alag service ka kharcha nahi. Tumhari subscription
me jo usage included hai usi me chalega. 3-4 halke bots aaram se chal
jate hain; jitne zyada/heavy bots, utna zyada CPU/RAM usage.

## Local test

```bash
npm install
DATA_DIR=./data PANEL_USER=admin PANEL_PASS=admin123 node server.js
# http://localhost:3000
```

## Security notes

- `PANEL_PASS` mazboot rakho — jis ke paas panel access hai wo tumhare
  Railway par code chala sakta hai.
- Bot env variables `/data/panel-state.json` me save hoti hain (volume
  par, repo me nahi jati — GitHub par push nahi hotin).
- Ye panel sirf tumhare liye hai; public "free hosting" service ke tor
  par mat kholo.

## Features

- ➕ GitHub se bot add (auto clone + install detect: npm/yarn/pnpm/pip)
- ▶ ⏹ ↻ Start / Stop / Restart
- ⬇ Redeploy (git pull + reinstall + restart)
- 📜 Live logs (auto-rotate)
- ⚙ Env variables edit
- 🔁 Crash par auto-restart (backoff ke sath)
- 💾 Volume par persistence — redeploy par kuch nahi mit-ta
- 🔐 Password login
