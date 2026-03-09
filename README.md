# Quarto-Obsidian Template

A template for maintaining notes as an [Obsidian](https://obsidian.md/) vault and rendering them as a [Quarto](https://quarto.org/) website. Includes wikilinks, citations, an interactive graph, dark mode, and deployment workflows for GitHub Pages and GitLab Pages.

The included demo notes showcase template features. Delete them and add your own.

## Prerequisites

- [Quarto](https://quarto.org/) (>= 1.4)
- [Docker](https://www.docker.com/) (optional, for devcontainer)
- [Obsidian](https://obsidian.md/) (optional, for editing)

## Setup

1. Click **Use this template** on GitHub to create your own repository.
2. Clone your new repository:

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
```

3. Update `_quarto.yml` to point to your repository:
   - `repo-url` - enables "View source" links on each page
   - The navbar icon `href` under `right:` - links the repo icon in the navbar
   - If hosting on GitLab instead of GitHub, change the icon from `github` to `gitlab`

**With devcontainer (recommended):** Open in VS Code and reopen in container when prompted.

**Locally:** Install Quarto, then:

```bash
quarto preview
```

The preview server runs on port 4200.

## Adding a new note

**In Obsidian:** Create a new note (it will be placed in `notes/` automatically), then insert the template via the command palette: *Templates: Insert template* and select **Note**.

**Manually:** Copy `notes/_template.md` to `notes/your-note-name.md`.

Then:

1. Write the title as a `# heading` (this becomes the page title on the website).
2. Fill in the YAML header (date, tags).
3. Write the note content using standard Pandoc markdown.
4. Add citations with `@citekey` syntax, referencing entries in `references.bib`.

New notes are automatically picked up by the listing page, with no manual updates required.

> **Tip:** If you need executable code chunks (R, Python, etc.), use the `.qmd` extension instead of `.md`. Both extensions are supported throughout the template.

## Removing demo notes

Delete the two demo notes and their references:

```bash
rm notes/hello-world.md notes/demo-features.md
```

You may also want to replace the dummy entries in `references.bib` with your own.

## Features

- **Listing page** - auto-lists all notes with tag/category filtering
- **Dark mode** - toggle between light (Cosmo) and dark (Darkly) themes
- **Wikilinks** - Obsidian-style `[[wikilinks]]` are converted to standard links at render time by `scripts/wikilinks.lua`. The alias syntax `[[target|display text]]` is also supported
- **Citations** - Pandoc `@citekey` syntax with Vancouver style via `vancouver.csl`
- **Interactive graph** - D3.js force-directed graph showing note connections and tags
- **Source links** - each rendered page links back to its source file on GitHub/GitLab
- **Tags** - use Obsidian-native `tags` in YAML front matter; the Lua filter automatically converts them to Quarto categories for the listing page

## Obsidian setup

1. Open the repository folder as a vault in Obsidian.
2. Notes use `.md` by default, so Obsidian will recognise them natively.
3. New notes are automatically created in `notes/`. Use *Templates: Insert template* (command palette) to apply the **Note** template.
4. To set your own default author name, edit `_templates/Note.md` and replace `"Your Name"` with your name.
5. If you create `.qmd` notes, install the [qmd-as-md](https://github.com/danieltomasz/qmd-as-md-obsidian) community plugin and enable **Settings > Files & Links > Detect all file extensions**.

### Syncing across devices

To access your vault on iOS (iPhone/iPad), clone or place the repository folder inside your iCloud Drive (e.g. `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/`). The Obsidian mobile app will detect it automatically. Changes sync both ways via iCloud.

## Foam / VS Code / Positron setup

[Foam](https://foamnotes.github.io/foam/) is a VS Code extension that provides Obsidian-like features (graph view, backlinks, wikilink navigation) inside VS Code or [Positron](https://positron.posit.co/).

1. Install the [Foam extension](https://marketplace.visualstudio.com/items?itemName=foam.foam-vscode).
2. Foam natively supports `[[wikilinks]]` in `.md` files, which is the default for this template.
3. Note: Foam does not resolve wikilinks in `.qmd` files. If you need executable code chunks, consider keeping the note as `.md` and renaming to `.qmd` only when you need to render it with code execution.

The devcontainer already includes useful VS Code extensions (Quarto, Markdown All in One, Code Spell Checker).

## PDFs

Key papers can be stored in `pdfs/` for co-location. The main reference library is managed externally via Zotero and BetterBibTeX, which exports to `references.bib`.

## Deployment

```bash
quarto render
```

This produces the site in `_output/`.

### GitHub Pages

A GitHub Actions workflow (`.github/workflows/deploy.yml`) automatically builds and deploys to GitHub Pages on push to `main`. Enable GitHub Pages in your repository settings and set the source to the `gh-pages` branch. Each deployment uses a force orphan push, so the `gh-pages` branch never accumulates history.

### GitLab Pages

A GitLab CI configuration (`.gitlab-ci.yml`) is also included. It renders the site and deploys to GitLab Pages on push to the default branch. No additional configuration is needed beyond enabling Pages in your GitLab project settings. GitLab Pages uses build artifacts rather than a branch, so there is no history accumulation.

### GitLab mirroring

A GitHub Actions workflow (`.github/workflows/mirror-gitlab.yml`) automatically pushes all branches and tags to a GitLab mirror on every push. To set this up:

1. Create a GitLab project with the same name.
2. Create a GitLab Personal Access Token with `write_repository` scope.
3. Add it as a GitHub Actions secret named `GITLAB_TOKEN`.
