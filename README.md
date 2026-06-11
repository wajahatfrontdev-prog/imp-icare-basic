# icare

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## LiveKit integration & deploy notes

- A LiveKit token endpoint was added at `icare-backend/routes/livekit.js` (POST `/api/livekit/token`).
- For local testing, add LiveKit env vars to `icare-backend/.env` or set them in Vercel:
	- `LIVEKIT_URL` (e.g. `wss://your.livekit.cloud`)
	- `LIVEKIT_API_KEY`
	- `LIVEKIT_API_SECRET`

### Quick build & deploy steps (what I prepared)

1. Install backend deps and run locally:

```powershell
cd "d:/ICare_app lms plus/icare-backend"
npm install
npm run dev
```

2. Build Flutter web release (Windows PowerShell):

```powershell
cd "d:/ICare_app lms plus"
\.\scripts\build_web.ps1
```

3. Commit & push to GitHub (example):

```powershell
git checkout -b feature/livekit-integration
git add .
git commit -m "feat: add LiveKit token endpoint + web demo + Jitsi hangup cleanup"
git push origin feature/livekit-integration
```

4. After push, deploy backend to Vercel and set the LiveKit env vars in Project Settings, then run `vercel --prod` or use Vercel dashboard.

I added a minimal demo at `web/livekit-demo.html` for manual testing against your backend.

