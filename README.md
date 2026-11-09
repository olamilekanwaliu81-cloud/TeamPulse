# TeamPulse prototype

A clickable prototype of TeamPulse, a monthly check-in system for a NeoLife team. It has a landing page and the app in one site, with example people and numbers.

**It stores nothing.** Each visitor sees their own copy of the example data in their own browser, and a refresh resets it.

Try it with these example accounts (password `demo1234`):

| TeamPulse ID | Who |
|---|---|
| `04OW000` | Team leader (Admin) |
| `04OW558` | Tunde, a QSM (sees only his downline) |
| `06OW209` | Blessing, a member |

You can also choose **Register as a team leader** to create your own empty team and add a first member.

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

## Before going public

The pages tell search engines not to list them, because they hold example data. Remove the `noindex` line in `scripts/build_site.py`, rebuild, and deploy again.
