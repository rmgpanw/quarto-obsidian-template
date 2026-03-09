#!/usr/bin/env python3
"""Extract wikilinks from note files (.md/.qmd) and write a graph JSON for the OJS visualisation."""

import json
import re
from pathlib import Path

NOTES_DIR = Path("notes")
OUTPUT_FILE = Path("_graph-data.json")

WIKILINK_RE = re.compile(r"\[\[([^\]|]+)(?:\|[^\]]+)?\]\]")
# Patterns for code spans and fenced code blocks to skip
CODE_BLOCK_RE = re.compile(r"^```.*?^```", re.MULTILINE | re.DOTALL)
INLINE_CODE_RE = re.compile(r"`[^`]+`")


def strip_code(text: str) -> str:
    """Remove fenced code blocks and inline code so wikilinks inside them are ignored."""
    text = CODE_BLOCK_RE.sub("", text)
    text = INLINE_CODE_RE.sub("", text)
    return text


def stem_to_title(stem: str) -> str:
    """Fallback: convert a filename stem to a readable title."""
    return stem.replace("-", " ").title()


def extract_front_matter(path: Path) -> dict:
    """Extract title, tags, and categories from YAML front matter."""
    result = {"title": None, "tags": []}
    try:
        text = path.read_text()
    except OSError:
        return result
    in_yaml = False
    categories = []
    tags = []
    for line in text.splitlines():
        if line.strip() == "---":
            if not in_yaml:
                in_yaml = True
                continue
            else:
                break
        if in_yaml:
            m = re.match(r'^title:\s*["\']?(.*?)["\']?\s*$', line)
            if m:
                result["title"] = m.group(1)
            for key in ("categories", "tags"):
                m = re.match(rf"^{key}:\s*\[(.+)\]\s*$", line)
                if m:
                    vals = [c.strip().strip("\"'") for c in m.group(1).split(",")]
                    if key == "categories":
                        categories.extend(vals)
                    else:
                        tags.extend(vals)
    # Merge tags and categories, deduplicating
    seen = set()
    merged = []
    for val in tags + categories:
        if val not in seen:
            seen.add(val)
            merged.append(val)
    result["tags"] = merged
    return result


def main() -> None:
    note_files = sorted(
        set(NOTES_DIR.glob("*.md")) | set(NOTES_DIR.glob("*.qmd"))
    )
    # Skip templates
    note_files = [f for f in note_files if f.name not in ("_template.md", "_template.qmd")]

    nodes = []
    links = []
    node_ids = set()
    seen_links = set()
    all_tags = set()

    for f in note_files:
        node_id = f.stem
        node_ids.add(node_id)
        fm = extract_front_matter(f)
        title = fm["title"] or stem_to_title(f.stem)
        tags = fm["tags"]
        all_tags.update(tags)
        nodes.append({
            "id": node_id,
            "title": title,
            "file": str(f),
            "tags": tags,
        })

        text = strip_code(f.read_text())
        for match in WIKILINK_RE.finditer(text):
            target = match.group(1).strip()
            # Strip file extension if present
            for ext in (".md", ".qmd"):
                if target.endswith(ext):
                    target = target[: -len(ext)]
                    break
            pair = (node_id, target)
            if pair not in seen_links:
                seen_links.add(pair)
                links.append({"source": node_id, "target": target})

    # Add placeholder nodes for targets that don't have their own file
    for link in links:
        if link["target"] not in node_ids:
            node_ids.add(link["target"])
            nodes.append({
                "id": link["target"],
                "title": stem_to_title(link["target"]),
                "file": None,
                "tags": [],
            })

    graph = {
        "nodes": nodes,
        "links": links,
        "tags": sorted(all_tags),
    }
    OUTPUT_FILE.write_text(json.dumps(graph, indent=2) + "\n")
    print(f"Graph: {len(nodes)} nodes, {len(links)} links, {len(all_tags)} tags -> {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
