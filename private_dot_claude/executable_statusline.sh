#!/usr/bin/env bash
# Claude Code status line: model · directory · git branch
input=$(cat)
python3 - "$input" <<'PY'
import json, os, subprocess, sys

d = json.loads(sys.argv[1])
model = d.get("model", {}).get("display_name", "?")
cwd = d.get("workspace", {}).get("current_dir") or os.getcwd()
home = os.path.expanduser("~")
short = "~" + cwd[len(home):] if cwd.startswith(home) else cwd

branch = ""
try:
    branch = subprocess.run(
        ["git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True, text=True, timeout=1).stdout.strip()
except Exception:
    pass

C = "\033[2m"; M = "\033[36m"; B = "\033[35m"; R = "\033[0m"
out = f"{M}{model}{R} {C}·{R} {short}"
if branch:
    out += f" {C}·{R} {B}{branch}{R}"
print(out)
PY
