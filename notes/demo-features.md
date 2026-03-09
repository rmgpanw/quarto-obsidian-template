---
author: "Your Name"
date: 2026-03-05
tags: [demo, features]
bibliography: ../references.bib
---

# Demo Features

## Purpose

This demo note shows how **wikilinks** and **citations** work in this project.

## Wikilinks

Obsidian-style `[[wikilinks]]` are automatically converted to standard links at render time by a Lua filter (`scripts/wikilinks.lua`). Source files are never modified.

**Plain wikilink:** Link to another note using `[[note-filename]]` syntax, for example, [[hello-world]].

**Aliased wikilink:** Use `[[target|display text]]` to customise the link text, for example, [[hello-world|the other demo note]].

## Citations

Citations use Pandoc's `@citekey` syntax, referencing entries in `references.bib`. For example, @demo2025 is a fictitious reference used here purely to show how inline citations render. Multiple citations can be grouped [@demo2025; @example2024].

## Summary

- This is a **demo note** showing wikilinks and citations.
- See [[hello-world]] for another feature demo.

## References

::: {#refs}
:::
