#!/usr/bin/env python3
"""Build the TeamPulse test site from the two page sources.

Sources (written for claude.ai Artifacts, which add <html>, <head> and the viewport tag):
  landing/index.html    the landing page
  prototype/index.html  the app prototype

Outputs:
  combined/index.html   ONE page: the landing page with the app inside it.
                        "Try the app" and the sign-in card open the app in the same page
                        (address ends in #app), and the app's logo returns to the landing page.
                        This is the file published as the single test link.
  site/index.html       the same one page, wrapped as a normal web page for Vercel
  site/app.html         the app on its own (so /app works too)
  site/vercel.json      Vercel settings

Run from anywhere:  python3 scripts/build_site.py
"""
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
SITE = ROOT / "site"
COMBINED = ROOT / "combined"

# Shown only if a viewer refuses to run the app inside the page.
FALLBACK_ARTIFACT = "https://claude.ai/artifact/3NZrnfxKCkFkpTi9eLVnsn"
FALLBACK_SITE = "app.html"

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

VIEW_CSS = """<style>
/* The app opens full screen on top of the landing page. */
#appview{position:fixed;inset:0;z-index:100;background:var(--bg)}
#appview iframe{display:block;width:100%;height:100%;border:0;background:var(--bg)}
#appfail{position:absolute;inset:0;display:grid;place-content:center;gap:14px;text-align:center;padding:24px;background:var(--bg);color:var(--ink)}
#appfail a{color:var(--accent);font-weight:700}
</style>"""

VIEW_HTML = """<div id="appview" hidden>
  <iframe id="appframe" title="TeamPulse app"></iframe>
  <div id="appfail" hidden role="alert"><p>The app could not open inside this page.</p><p><a href="__FALLBACK__" target="_blank" rel="noopener">Open the app on its own</a> &nbsp;·&nbsp; <a href="#" id="appback">Back to the landing page</a></p></div>
</div>"""

ROUTER_JS = r"""<script>
/* One-page router. #app shows the app, #app-signin shows it on the sign-in screen, no hash shows the landing page. */
(function(){
  const view=document.getElementById('appview'),frame=document.getElementById('appframe'),fail=document.getElementById('appfail'),tpl=document.getElementById('app-tpl');
  const parts=[document.getElementById('nav'),document.querySelector('main'),document.querySelector('footer')];
  let loaded=false;
  function check(){
    let ok=false;
    try{const r=frame.contentDocument&&frame.contentDocument.getElementById('root');ok=!!(r&&r.children.length)}catch(_){}
    fail.hidden=ok;
  }
  function load(){
    loaded=true;fail.hidden=true;
    frame.onload=()=>setTimeout(check,400);
    frame.srcdoc='<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><style>html,body{margin:0}</style></head><body>'+tpl.innerHTML+'</body></html>';
    setTimeout(()=>{if(!loaded)return;check()},5000);
  }
  function route(){
    const h=location.hash.slice(1),inApp=h==='app'||h==='app-signin'||h==='app-register';
    view.hidden=!inApp;
    parts.forEach(p=>{if(p)p.inert=inApp});
    document.documentElement.style.overflow=inApp?'hidden':'';
    if(!inApp)return;
    if(!loaded)load();
    else if(h==='app-signin'){try{frame.contentWindow.openSigninFromLanding()}catch(_){}}
    else if(h==='app-register'){try{frame.contentWindow.openRegisterFromLanding()}catch(_){}}
    setTimeout(()=>{
      try{
        frame.focus();const w=frame.contentWindow;w.focus();
        if(h==='app-signin'){const el=w.document.getElementById('si-pw')||w.document.getElementById('si-id');if(el)el.focus()}
        if(h==='app-register'){const el=w.document.getElementById('rg-name');if(el)el.focus()}
      }catch(_){}
    },500);
  }
  window.addEventListener('hashchange',route);
  window.addEventListener('message',e=>{if(e.source===frame.contentWindow&&e.data&&e.data.tp==='home')location.hash=''});
  document.getElementById('appback').addEventListener('click',e=>{e.preventDefault();location.hash=''});
  route();
})();
</script>"""


def read(path: pathlib.Path) -> str:
    text = path.read_text(encoding="utf-8").strip()
    if "<!doctype" in text.lower() or "<html" in text.lower():
        raise SystemExit(f"{path} already has a document wrapper; expected the Artifact form.")
    return text


def human_size(path: pathlib.Path, fallback: str) -> str:
    """Size of a download for the website text, for example "0.3 MB"."""
    if not path.exists():
        return fallback
    kb = path.stat().st_size / 1024
    return f"{kb / 1024:.1f} MB" if kb >= 1024 else f"{max(1, round(kb))} KB"


def fill_downloads(landing: str) -> str:
    downloads = SITE / "downloads"
    landing = landing.replace("{{MAC_SIZE}}", human_size(downloads / "TeamPulse-mac.zip", "under 1 MB"))
    return landing.replace("{{WIN_SIZE}}", human_size(downloads / "TeamPulse-windows.zip", "under 1 MB"))


def combine(landing: str, app: str, fallback: str) -> str:
    """The landing page with the app tucked inside an inert <template>, shown in a full-screen frame."""
    return (
        landing
        + "\n"
        + VIEW_CSS
        + "\n"
        + VIEW_HTML.replace("__FALLBACK__", fallback)
        + '\n<template id="app-tpl">\n'
        + app
        + "\n</template>\n"
        + ROUTER_JS
        + "\n"
    )


def main() -> None:
    landing = fill_downloads(read(ROOT / "landing" / "index.html"))
    app = read(ROOT / "prototype" / "index.html")

    COMBINED.mkdir(exist_ok=True)
    SITE.mkdir(exist_ok=True)

    (COMBINED / "index.html").write_text(combine(landing, app, FALLBACK_ARTIFACT), encoding="utf-8")
    print("wrote combined/index.html  (publish this as the single test link)")

    (SITE / "index.html").write_text(HEAD + combine(landing, app, FALLBACK_SITE) + TAIL, encoding="utf-8")
    (SITE / "app.html").write_text(HEAD + app + TAIL, encoding="utf-8")
    (SITE / "vercel.json").write_text(json.dumps({"cleanUrls": True}, indent=2) + "\n", encoding="utf-8")
    print("wrote site/index.html, site/app.html, site/vercel.json  (deploy the site folder)")


if __name__ == "__main__":
    main()
