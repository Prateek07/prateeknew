#!/usr/bin/env python3
"""Create an Azure Functions zip package with host.json at the archive root."""

from __future__ import annotations

import argparse
import os
import sys
import zipfile
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description="Package an Azure Functions project for zip deployment.")
    parser.add_argument("--source", required=True, help="Function project folder containing host.json")
    parser.add_argument("--output", required=True, help="Output zip path")
    args = parser.parse_args()

    source = Path(args.source).resolve()
    output = Path(args.output).resolve()

    host_json = source / "host.json"
    if not host_json.is_file():
        raise FileNotFoundError(f"host.json not found at {host_json}. The package root must contain host.json.")

    output.parent.mkdir(parents=True, exist_ok=True)
    if output.exists():
        output.unlink()

    with zipfile.ZipFile(output, "w", zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(source.rglob("*")):
            if path.is_dir():
                continue
            rel = path.relative_to(source)
            if any(part in {".git", ".terraform", "__pycache__"} for part in rel.parts):
                continue
            archive.write(path, rel.as_posix())

    with zipfile.ZipFile(output, "r") as archive:
        names = set(archive.namelist())
        if "host.json" not in names:
            raise RuntimeError("Invalid package: host.json is not at the zip root.")

    print(f"Created package: {output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
