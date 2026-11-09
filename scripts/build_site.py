#!/usr/bin/env python3
"""Build the deployable TeamPulse site from the two page sources.

  landing/index.html    -> site/index.html   (landing page)
  prototype/index.html  -> site/app.html     (app prototype)

The sources are written for claude.ai Artifacts, which add the <html>, <head> and
viewport tags when they publish. A normal web host does not, so this script wraps
each page in a complete HTML document and writes the Vercel settings.

Run it from anywhere:  python3 scripts/build_site.py
"""
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
SITE = ROOT / "site"

HEAD = (
    '<!doctype html><html lang="en"><head><meta charset="utf-8">'
    '<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">'
    # Test deployment with example data: keep it out of search engines. Remove this line to go public.
    '<meta name="robots" content="noindex">'
    "<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);"
    "padding-bottom:env(safe-area-inset-bottom,0px)}html{-webkit-text-size-adjust:100%}"
    "body{margin:0;padding:0;font:14px -apple-system,BlinkMacSystemFont,sans-serif;background:#fff;color:#000}"
    "img{max-width:100%}[hidden]:not([hidden=until-found i]){display:none!important}</style>"
    "</head><body>\n"
)
TAIL = "\n</body></html>\n"

PAGES = {
    "index.html": ROOT / "landing" / "index.html",
    "app.html": ROOT / "prototype" / "index.html",
}


def main() -> None:
    SITE.mkdir(exist_ok=True)
    for name, src in PAGES.items():
        body = src.read_text(encoding="utf-8").strip()
        if "<!doctype" in body.lower() or "<html" in body.lower():
            raise SystemExit(f"{src} already has a document wrapper; expected the Artifact form.")
        (SITE / name).write_text(HEAD + body + TAIL, encoding="utf-8")
        print(f"wrote site/{name} ({len(body):,} bytes of page)")
    # cleanUrls: /app works as well as /app.html
    (SITE / "vercel.json").write_text(json.dumps({"cleanUrls": True}, indent=2) + "\n", encoding="utf-8")
    print("wrote site/vercel.json")


if __name__ == "__main__":
    main()
