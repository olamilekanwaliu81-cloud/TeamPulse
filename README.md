# TeamPulse prototype

A working prototype of TeamPulse, a monthly check-in system for a NeoLife team. It has a landing page and the app in one site, and it behaves like the real product: accounts, sign-in, check-ins and a dashboard, with no sample data.

**Everything you enter is stored in your own browser only.** Nothing is sent anywhere, and there is no server. The real app (next step) uses a database and sends real emails.

## Try it

1. Open the site and choose **Register as a team leader**. Fill in the form.
2. The app "sends" a confirmation email. Open **Test tools** (bottom right) to read it and click its link.
3. You land in your own empty team. Choose **Add a member** and fill in the form. That member's welcome email appears in the test mailbox, with a **Set my password** button.
4. Sign out, open that link, set the member's password, and see the member's side. Sign out again and sign in as the team leader with your TeamPulse ID and password.

**Test tools** is only for this prototype. It shows the emails the app sends, lets you move the date (check-ins open on set days) and deletes all data. The real app does these things by itself.

## Folders

| Path | What it is |
|---|---|
| `site/` | **The deployable site.** `index.html` is the landing page with the app inside it, `app.html` is the app on its own, `vercel.json` is the Vercel setting. |
| `landing/index.html` | Source of the landing page. |
| `prototype/index.html` | Source of the app. |
| `scripts/build_site.py` | Rebuilds `site/` from the two sources. |
| `scripts/serve.py` | Serves `site/` on your computer for testing. |

Edit the two source files, then rebuild. Do not edit `site/` by hand.

```bash
python3 scripts/build_site.py
```

## Run it on your computer

```bash
PORT=5612 python3 scripts/serve.py
```

Open http://127.0.0.1:5612/ and stop it with Ctrl+C.

## Push to GitHub

1. Create an empty repository on GitHub (private is fine). Do not add a README there.
2. In a terminal, from this folder:

```bash
git init
```

```bash
git add .
```

```bash
git commit -m "TeamPulse prototype"
```

```bash
git branch -M main
```

```bash
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git
```

```bash
git push -u origin main
```

## Deploy from GitHub to Vercel

1. In Vercel choose **Add New, Project** and import the repository.
2. Set **Root Directory** to `site`.
3. Set **Framework Preset** to **Other**. Leave the build command and output directory empty.
4. Deploy.

Or deploy from this computer without GitHub:

```bash
cd site && npx vercel
```

## Mac app

`macos/` builds **TeamPulse.app**, a small native Mac app that opens this site in its own window, works without internet (it uses system fonts when offline) and runs on Intel and Apple Silicon Macs (macOS 12 or newer).

```bash
bash macos/build_mac.sh
```

It needs only Apple's Command Line Tools and takes under a minute. It creates `macos/dist/TeamPulse.app` and `macos/dist/TeamPulse-prototype.dmg`. To install, open the DMG and drag TeamPulse to Applications.

Check the built app without opening a window:

```bash
macos/dist/TeamPulse.app/Contents/MacOS/TeamPulse --selftest
```

The app is signed for the Mac that built it. On another Mac the first open needs one extra step because the app is not notarized by Apple: macOS 15 asks you to open System Settings > Privacy & Security and choose "Open Anyway"; macOS 14 or older: Control-click the app, choose Open.

## Downloads on the website

The landing page has a **Download** section with one file for Mac and one for Windows (the page highlights the one that matches the visitor's computer). The files live in `site/downloads/` and are built by:

```bash
bash scripts/build_all.sh
```

- `TeamPulse-mac.zip`: TeamPulse.app (Intel + Apple Silicon) with a short read-me.
- `TeamPulse-windows.zip`: an installer script that opens TeamPulse in its own Edge/Chrome app window, plus uninstaller. It is not a compiled .exe and has not been tested on a real Windows PC yet.
- Both are unsigned, so Mac and Windows show a warning the first time. The read-me inside each zip explains the click-through.
- Inside the desktop app the download section is hidden.

## Before going public

The pages tell search engines not to list them, because they hold example data. Remove the `noindex` line in `scripts/build_site.py`, rebuild, and deploy again.
