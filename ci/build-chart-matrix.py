#!/usr/bin/env python3
import argparse
import json
import os
import re
import subprocess

import yaml

CHARTS_DIR = "charts"
CONFIG_FILE = "ci/ct-install-config.yaml"


def load_excluded():
    if not os.path.exists(CONFIG_FILE):
        return set()
    with open(CONFIG_FILE) as f:
        data = yaml.safe_load(f) or {}
    return set(data.get("excluded-charts", []))


def get_all_charts():
    return sorted(
        [
            d
            for d in os.listdir(CHARTS_DIR)
            if os.path.isdir(os.path.join(CHARTS_DIR, d))
        ]
    )


def get_changed():
    try:
        out = subprocess.check_output(["ct", "list-changed"], text=True)
    except subprocess.CalledProcessError:
        return []

    return sorted(
        set(
            line.split("/")[1]
            for line in out.splitlines()
            if line.startswith("charts/")
        )
    )


def extract_deps(chart):
    path = f"{CHARTS_DIR}/{chart}/ci/prepare.sh"
    if not os.path.exists(path):
        return []

    with open(path) as f:
        content = f.read()

    return re.findall(r"install_chart\s+([a-zA-Z0-9._-]+)", content)


def build_reverse_graph(charts):
    graph = {}
    for chart in charts:
        for dep in extract_deps(chart):
            graph.setdefault(dep, []).append(chart)
    return graph


def expand(changed, graph, excluded):
    result = set()
    stack = list(changed)

    while stack:
        current = stack.pop()

        if current in result or current in excluded:
            continue

        result.add(current)

        for dep in graph.get(current, []):
            stack.append(dep)

    return sorted(result)


def parse_manual_input(raw):
    return sorted(set([c.strip() for c in raw.split(",") if c.strip()]))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--charts", help="Comma-separated list of charts to run (manual override)"
    )
    return parser.parse_args()


def main():
    args = parse_args()
    manual_input = (args.charts or "").strip()

    if manual_input:
        charts = parse_manual_input(manual_input)
        print(json.dumps(charts))
        return

    excluded = load_excluded()
    changed = get_changed()
    all_charts = get_all_charts()

    if changed:
        graph = build_reverse_graph(all_charts)
        charts = expand(changed, graph, excluded)
    else:
        charts = [c for c in all_charts if c not in excluded]

    print(json.dumps(charts))


if __name__ == "__main__":
    main()
