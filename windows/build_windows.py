#!/usr/bin/env python3
"""Builds the Windows download: site/downloads/TeamPulse-windows.zip

The zip holds the TeamPulse site (landing page + app), an installer that opens it in its own
Edge or Chrome app window, an uninstaller and a read-me. Nothing needs compiling.

Run from anywhere (on a Mac, because the icon is drawn with macOS tools):

    python3 windows/build_windows.py

Run scripts/build_site.py first so site/index.html and site/app.html are up to date.
"""
import pathlib
import struct
import subprocess
import tempfile
import zipfile

ROOT = pathlib.Path(__file__).resolve().parent.parent
PACKAGE = ROOT / "windows" / "package"
SITE = ROOT / "site"
OUT = SITE / "downloads" / "TeamPulse-windows.zip"
FOLDER = "TeamPulse for Windows"
TEXT_SUFFIXES = {".cmd", ".ps1", ".txt"}


def draw_icon_pngs(workdir: pathlib.Path) -> pathlib.Path:
    """Draws the app icon at every size, using the same drawing code as the Mac app."""
    binary = workdir / "make_icon"
    subprocess.run(
        ["clang", "-fobjc-arc", "-framework", "Cocoa", str(ROOT / "macos" / "make_icon.m"), "-o", str(binary)],
        check=True,
    )
    iconset = workdir / "icons"
    subprocess.run([str(binary), str(iconset)], check=True, stdout=subprocess.DEVNULL)
    return iconset


def make_ico(iconset: pathlib.Path) -> bytes:
    """Packs PNG frames into one .ico file (Windows Vista and later read PNG frames)."""
    frames = [(16, "icon_16x16.png"), (32, "icon_32x32.png"), (64, "icon_32x32@2x.png"),
              (128, "icon_128x128.png"), (256, "icon_256x256.png")]
    images = [(size, (iconset / name).read_bytes()) for size, name in frames]
    header = struct.pack("<HHH", 0, 1, len(images))
    offset = 6 + 16 * len(images)
    entries, data = b"", b""
    for size, png in images:
        dim = 0 if size >= 256 else size  # 0 means 256 in the .ico format
        entries += struct.pack("<BBBBHHII", dim, dim, 0, 0, 1, 32, len(png), offset + len(data))
        data += png
    return header + entries + data


def crlf(raw: bytes) -> bytes:
    text = raw.decode("utf-8").replace("\r\n", "\n").replace("\n", "\r\n")
    return text.encode("utf-8")


def add(zf: zipfile.ZipFile, arcname: str, data: bytes) -> None:
    info = zipfile.ZipInfo(f"{FOLDER}/{arcname}", date_time=(2026, 11, 9, 12, 0, 0))
    info.compress_type = zipfile.ZIP_DEFLATED
    info.external_attr = 0o644 << 16
    zf.writestr(info, data)


def main() -> None:
    for name in ("index.html", "app.html"):
        if not (SITE / name).exists():
            raise SystemExit(f"site/{name} is missing. Run scripts/build_site.py first.")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        ico = make_ico(draw_icon_pngs(pathlib.Path(tmp)))

    with zipfile.ZipFile(OUT, "w") as zf:
        for path in sorted(PACKAGE.rglob("*")):
            if path.is_dir():
                continue
            rel = path.relative_to(PACKAGE).as_posix()
            raw = path.read_bytes()
            add(zf, rel, crlf(raw) if path.suffix.lower() in TEXT_SUFFIXES else raw)
        add(zf, "files/TeamPulse.ico", ico)
        for name in ("index.html", "app.html"):
            add(zf, f"files/app/{name}", (SITE / name).read_bytes())
    print(f"wrote {OUT.relative_to(ROOT)} ({OUT.stat().st_size / 1024:.0f} KB)")


if __name__ == "__main__":
    main()
