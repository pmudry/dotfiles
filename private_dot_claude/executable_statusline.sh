#!/usr/bin/env bash
# Claude Code status line: model · directory · git branch · usage
input=$(cat)
python3 - "$input" <<'PY'
import json, os, subprocess, sys

KEEP = 2  # trailing components kept in full; earlier ones shrink to one letter


def shorten(path):
    """~/git/isc/admin/isc-eee/web -> ~/g/i/isc-eee/web"""
    home = os.path.expanduser("~")
    if path == home:
        return "~"
    if path.startswith(home + os.sep):
        head, rest = "~", path[len(home) + 1:]
    elif path == os.sep:
        return os.sep
    else:
        head, rest = "", path.lstrip(os.sep)
    parts = [p for p in rest.split(os.sep) if p]
    cut = len(parts) - KEEP
    out = [p if i >= cut else (p[:2] if p.startswith(".") else p[:1])
           for i, p in enumerate(parts)]
    return os.sep.join([head] + out) if head else os.sep + os.sep.join(out)


d = json.loads(sys.argv[1])
model = d.get("model", {}).get("display_name", "?")
cwd = d.get("workspace", {}).get("current_dir") or os.getcwd()
short = shorten(cwd)

branch = ""
try:
    branch = subprocess.run(
        ["git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD"],
        capture_output=True, text=True, timeout=1).stdout.strip()
except Exception:
    pass

usage = []

# context window fill; null until the first exchange of a session
p = (d.get("context_window") or {}).get("used_percentage")
if isinstance(p, (int, float)):
    usage.append(f"{round(p)}% ctx")

# plan quotas; absent on API-key sessions
limits = d.get("rate_limits") or {}
for key, label in (("five_hour", "5h"), ("seven_day", "7d")):
    w = limits.get(key) if isinstance(limits, dict) else None
    v = w.get("used_percentage") if isinstance(w, dict) else None
    if isinstance(v, (int, float)):
        usage.append(f"{label} {round(v)}%")

C = "\033[2m"; M = "\033[36m"; B = "\033[35m"; Y = "\033[33m"; R = "\033[0m"
sep = f" {C}·{R} "
out = f"{M}{model}{R}{sep}{short}"
if branch:
    out += f"{sep}{B}{branch}{R}"
if usage:
    out += sep + sep.join(f"{Y}{u}{R}" for u in usage)
print(out)
PY
