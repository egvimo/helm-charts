#!/usr/bin/env python3
import json
import os
import re
import subprocess

CHARTS_DIR = "charts"


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

    deps = re.findall(r"install_chart\s+([a-zA-Z0-9._-]+)", content)

    return deps


def build_reverse_graph():
    graph = {}
    for chart in os.listdir(CHARTS_DIR):
        for dep in extract_deps(chart):
            graph.setdefault(dep, []).append(chart)
    return graph


def expand(changed, graph):
    result = set()
    stack = list(changed)

    while stack:
        current = stack.pop()
        if current in result:
            continue
        result.add(current)
        stack.extend(graph.get(current, []))

    return sorted(result)


def main():
    changed = get_changed()

    if not changed:
        charts = sorted(os.listdir(CHARTS_DIR))
    else:
        graph = build_reverse_graph()
        charts = expand(changed, graph)

    print(json.dumps(charts))


if __name__ == "__main__":
    main()
