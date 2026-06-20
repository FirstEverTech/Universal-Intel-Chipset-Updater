#!/usr/bin/env python3
import os, sys, math, requests, numpy as np, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from datetime import datetime, timezone
from pathlib import Path

REPO    = os.environ["REPO"]
TOKEN   = os.environ.get("GITHUB_TOKEN")
HEADERS = {
    "Accept": "application/vnd.github.v3.star+json",
    "Authorization": f"Bearer {TOKEN}",
}

def fetch_stars(repo):
    dates, page = [], 1
    while True:
        r = requests.get(
            f"https://api.github.com/repos/{repo}/stargazers",
            headers=HEADERS, params={"per_page": 100, "page": page}, timeout=30,
        )
        r.raise_for_status()
        data = r.json()
        if not data:
            break
        dates += [datetime.fromisoformat(i["starred_at"].rstrip("Z")) for i in data]
        page += 1
    return sorted(dates)

# ---------- COLORS ----------
BLUE     = "#58a6ff"
LINE     = "#1f6feb"
GRID_MAJ = "#283d58"

def x_axis_config(start: datetime, end: datetime):
    """Returns (locator, formatter, xlabel) based on span."""
    days  = (end - start).days
    years = days / 365.25

    if days < 32:
        loc = mdates.FixedLocator(mdates.date2num([start, end]))
        fmt = mdates.DateFormatter("%b '%y")
        lbl = "Date"
    elif years < 1:
        loc = mdates.MonthLocator()
        fmt = mdates.DateFormatter("%b '%y")
        lbl = "Month"
    elif years < 3:
        loc = mdates.MonthLocator(bymonth=[1, 4, 7, 10])
        fmt = mdates.DateFormatter("%b '%y")
        lbl = "Quarter"
    elif years < 6:
        loc = mdates.MonthLocator(bymonth=[1, 7])
        fmt = mdates.DateFormatter("%b '%y")
        lbl = "Half-year"
    elif years < 10:
        loc = mdates.YearLocator()
        fmt = mdates.DateFormatter("%Y")
        lbl = "Year"
    else:
        loc = mdates.YearLocator(2)
        fmt = mdates.DateFormatter("%Y")
        lbl = "Year"

    return loc, fmt, lbl

def generate(dates, repo, out):
    counts  = list(range(1, len(dates) + 1))
    owner, name = repo.split("/")
    now     = datetime.utcnow()
    x_start = dates[0]
    x_end   = now

    fig, ax = plt.subplots(figsize=(10, 3.2), dpi=150)
    fig.patch.set_facecolor("none")
    ax.set_facecolor("none")

    date_nums = mdates.date2num(dates)

    # Line + fill
    ax.plot(dates, counts, color=LINE, linewidth=2.5, zorder=3)
    ax.fill_between(dates, counts, color=LINE, alpha=0.15, zorder=2)

    # 31 evenly spaced dots across the full span
    x31 = np.linspace(mdates.date2num(x_start), mdates.date2num(x_end), 31)
    y31 = np.interp(x31, date_nums, counts)
    ax.scatter(mdates.num2date(x31), y31, color=BLUE, s=30, zorder=4, linewidths=0)

    # ---------- MARGINS TO PREVENT DOTS FROM BEING CUT OFF ----------
    # Horizontal margins: 2% on each side
    x_pad = (x_end - x_start) * 0.02
    ax.set_xlim(x_start - x_pad, x_end + x_pad)

    # Y axis: 8 lines, 0 at bottom, nice max at top, plus half a step above
    NUM_Y_LINES = 8
    y_max = max(counts)
    step = math.ceil(y_max / (NUM_Y_LINES - 1)) if y_max > 0 else 1
    nice_max = step * (NUM_Y_LINES - 1)
    if nice_max < NUM_Y_LINES - 1:
        nice_max = NUM_Y_LINES - 1

    # Add half a step above the top line to create a small gap
    ax.set_ylim(0, nice_max + step * 0.5)
    ax.set_yticks(np.linspace(0, nice_max, NUM_Y_LINES))

    # ---------- GRID (dotted, new color) ----------
    ax.set_axisbelow(True)
    loc, fmt, x_lbl = x_axis_config(x_start, x_end)
    ax.xaxis.set_major_locator(loc)
    ax.xaxis.set_major_formatter(fmt)
    ax.grid(True, which="major", color=GRID_MAJ, linewidth=0.7, linestyle=':')

    # Tick styling
    ax.tick_params(axis="both", which="both", colors=BLUE, labelsize=7)
    fig.autofmt_xdate(rotation=0, ha="center")
    for lbl in ax.get_xticklabels() + ax.get_yticklabels():
        lbl.set_fontweight("bold")
        lbl.set_color(BLUE)

    for spine in ax.spines.values():
        spine.set_edgecolor(GRID_MAJ)

    ax.set_ylabel("Stars", color=BLUE, fontsize=8,
                  fontfamily="DejaVu Sans", fontweight="bold")
    ax.set_xlabel(x_lbl,   color=BLUE, fontsize=8,
                  fontfamily="DejaVu Sans", fontweight="bold")
    ax.set_title(
        f"{owner} / {name} · Star History",
        color=BLUE, fontsize=10, fontweight="normal",
        fontfamily="DejaVu Sans", pad=10,
    )

    plt.tight_layout(pad=0.8)
    out.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out, format="svg", bbox_inches="tight", transparent=True)
    plt.close(fig)

if __name__ == "__main__":
    stars = fetch_stars(REPO)
    if not stars:
        sys.exit(0)
    generate(stars, REPO, Path("assets/star-history.svg"))
