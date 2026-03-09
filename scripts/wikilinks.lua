--- Pandoc Lua filter for Obsidian-Quarto compatibility.
--- 1. Converts [[wikilinks]] to standard markdown links.
--- 2. Merges Obsidian `tags` into Quarto `categories` for the listing page.
--- Runs at render time inside Pandoc; source files are never mutated.

--- Merge tags into categories so Obsidian tags appear on Quarto listing pages.
function Meta(meta)
  if meta.tags then
    local cats = meta.categories or pandoc.MetaList({})
    -- Collect existing categories for deduplication
    local seen = {}
    for _, c in ipairs(cats) do
      seen[pandoc.utils.stringify(c)] = true
    end
    for _, t in ipairs(meta.tags) do
      local val = pandoc.utils.stringify(t)
      if not seen[val] then
        cats[#cats + 1] = t
        seen[val] = true
      end
    end
    meta.categories = cats
    return meta
  end
end

function Str(el)
  -- Match wikilinks with alias: [[target|display]]
  local target, display = el.text:match("^%[%[(.-)%|(.-)%]%]$")
  if target and display then
    local url = resolve_target(target)
    return pandoc.Link(display, url)
  end

  -- Match plain wikilinks: [[target]]
  target = el.text:match("^%[%[(.-)%]%]$")
  if target then
    local url = resolve_target(target)
    return pandoc.Link(target, url)
  end

  return nil
end

function Inlines(inlines)
  local result = pandoc.List()
  local i = 1
  while i <= #inlines do
    -- Look for a sequence starting with Str("[[")
    if inlines[i].t == "Str" and inlines[i].text:match("^%[%[") then
      -- Collect all elements until we find one ending with "]]"
      local parts = { inlines[i].text }
      local j = i + 1
      local found_end = inlines[i].text:match("%]%]$") ~= nil

      if not found_end then
        while j <= #inlines do
          if inlines[j].t == "Str" then
            parts[#parts + 1] = inlines[j].text
            if inlines[j].text:match("%]%]$") then
              found_end = true
              j = j + 1
              break
            end
          elseif inlines[j].t == "Space" or inlines[j].t == "SoftBreak" then
            parts[#parts + 1] = " "
          else
            -- Non-text element breaks the wikilink sequence
            break
          end
          j = j + 1
        end
      end

      if found_end then
        local combined = table.concat(parts)
        -- Try alias syntax first
        local target, display = combined:match("^%[%[(.-)%|(.-)%]%]$")
        if target and display then
          result:insert(pandoc.Link(display, resolve_target(target)))
          i = j
        else
          target = combined:match("^%[%[(.-)%]%]$")
          if target then
            result:insert(pandoc.Link(target, resolve_target(target)))
            i = j
          else
            result:insert(inlines[i])
            i = i + 1
          end
        end
      else
        result:insert(inlines[i])
        i = i + 1
      end
    else
      result:insert(inlines[i])
      i = i + 1
    end
  end
  return result
end

function resolve_target(target)
  -- If target already has an extension, use it as-is
  if target:match("%.[%a]+$") then
    return target
  end
  -- Append .html so links work regardless of source extension (.md or .qmd)
  return target .. ".html"
end
