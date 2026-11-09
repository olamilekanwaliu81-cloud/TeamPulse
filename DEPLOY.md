# Deploying the TeamPulse test site

The landing page and the app prototype are one site, ready to deploy from the `site/` folder.

| File | What it is |
|---|---|
| `site/index.html` | The landing page. Its "Sign in" card hands the TeamPulse ID to the app. "Try the app" opens the app. |
| `site/app.html` | The app prototype. Its logo and "Landing page" button go back to the landing page. |
| `site/vercel.json` | Vercel settings. It makes `/app` work as well as `/app.html`. |

## What this test is, and is not

- It is a **walk-through of the real screens** with example people and numbers. Sign in with `06OW209` and the password `demo1234`, or `04OW000` for the team leader.
- It **stores nothing**. Each visitor sees their own copy of the example data in their own browser, and a refresh resets it. Distributors cannot really sign up or send answers yet.
- The real software (database, real emails, real passwords) is the next build.
- The site tells search engines not to list it (`noindex`). Remove that line from `scripts/build_site.py` when you go public, then rebuild.

## Deploy to Vercel

You already use Vercel for your publishing site, so your account should be ready.

1. Open a terminal in the site folder:

```bash
cd "/Users/bizzero/untitled folder/Documents/Coding/TeamPulse/site"
```

2. Sign in to Vercel the first time only:

```bash
npx vercel login
```

3. Deploy a test copy and open the link it prints:

```bash
npx vercel
```

4. When you are happy, publish it at your main address:

```bash
npx vercel --prod
```

When it asks questions the first time, answer: set up and deploy: **yes**; link to an existing project: **no**; project name: **teampulse**; directory: **./**.

## After any change

The page sources are `landing/index.html` and `prototype/index.html`. Rebuild the site folder, then deploy again:

```bash
python3 scripts/build_site.py
```

## One link without Vercel

The same two pages are also published together as one private test page at https://claude.ai/artifact/QbKG27kYVE8tiX8ST52ryJ. Share it from that page's Share menu to let others open it.
