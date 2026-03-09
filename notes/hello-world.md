---
author: Your Name
date: 2026-03-06
tags:
  - demo
  - layout
bibliography: ../references.bib
---

# Hello World

## Purpose

This demo note shows how **categories** and the **listing page** work.

## Categories

Each note specifies `tags` in its YAML front matter. These appear in Obsidian's tag pane and are automatically converted to Quarto categories for the listing page.

``` yaml
tags: [demo, layout]
```

## Listing Page

The home page (`index.qmd`) uses Quarto's built-in [listing](https://quarto.org/docs/websites/website-listings.html) feature to automatically display all notes in the `notes/` directory. New notes are picked up automatically, with no need to manually update the home page.

## Template

To create a new note, copy `notes/_template.md` and fill in the YAML header. See the project README for full instructions.

## Summary

-   This is a **demo note** showing categories and the listing page.
-   See \[\[demo-features\]\] for a demo of wikilinks and citations.

## References

::: {#refs}
:::