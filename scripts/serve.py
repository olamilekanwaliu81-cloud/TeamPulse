#!/usr/bin/env python3
"""Serve the built site (site/) locally for testing. Reads the port from $PORT (default 5191)."""
import functools
import http.server
import os
import pathlib

SITE = pathlib.Path(__file__).resolve().parent.parent / "site"
PORT = int(os.environ.get("PORT", "5191"))

handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(SITE))
with http.server.ThreadingHTTPServer(("127.0.0.1", PORT), handler) as server:
    print(f"Serving {SITE} on http://127.0.0.1:{PORT}", flush=True)
    server.serve_forever()
