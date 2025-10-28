-- ============================================================================
-- FILE: markdown.lua
-- PURPOSE: Enhanced Markdown configuration with autocompletion and snippets
-- LOCATION: ~/neovim-config/lua/evanusmodestus/modules/plugins/markdown.lua
-- ============================================================================
--
-- WHAT THIS FILE DOES:
-- 1. Provides LuaSnip snippets for common markdown patterns (code blocks, links, etc.)
-- 2. Creates Obsidian-compatible YAML frontmatter snippets
-- 3. Sets up markdown-specific autocompletion (including spell check)
-- 4. Adds markdown-specific keybindings for formatting
-- 5. Provides validation commands for Obsidian frontmatter
--
-- THIS IS DIFFERENT FROM obsidian-templates.lua:
-- - obsidian-templates.lua = Full document templates (projects, incidents, tasks)
-- - markdown.lua (this file) = Quick snippets and markdown utilities
--
-- DEPENDENCIES:
-- - LuaSnip (snippet engine)
-- - nvim-cmp (completion)
-- - Optional: glow (terminal markdown preview)
-- - Optional: markdown-preview.nvim
--
-- ============================================================================

local M = {}

-- ============================================================================
-- SNIPPET SETUP
-- ============================================================================
-- Creates snippets for common markdown patterns and Obsidian frontmatter

function M.setup()
    -- Import LuaSnip
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    -- Register all markdown snippets
    ls.add_snippets("markdown", {

        -- ====================================================================
        -- BASIC MARKDOWN SNIPPETS
        -- ====================================================================
        -- These are for quick markdown formatting

        -- Code block with syntax highlighting
        s("code", {
            t("```"),
            i(1, "language"),
            t({"", ""}),
            i(2, "code"),
            t({"", "```"}),
        }),

        -- Markdown link
        s("link", {
            t("["),
            i(1, "text"),
            t("]("),
            i(2, "url"),
            t(")"),
        }),

        -- Clipboard link (paste URL from clipboard, cursor in text)
        s("linkc", {
            t("["),
            i(1, "text"),
            t("]("),
            f(function()
                -- Get clipboard content and strip whitespace/newlines
                local clipboard = vim.fn.getreg("+")
                if clipboard and clipboard ~= "" then
                    -- Remove all whitespace and newlines
                    local cleaned = string.gsub(clipboard, "%s+", "")
                    return cleaned
                end
                return "url"
            end, {}),
            t(")"),
        }),

        -- Image embed
        s("img", {
            t("!["),
            i(1, "alt text"),
            t("]("),
            i(2, "image url"),
            t(")"),
        }),

        -- Bold text
        s("bold", {
            t("**"),
            i(1, "text"),
            t("**"),
        }),

        -- Italic text
        s("italic", {
            t("*"),
            i(1, "text"),
            t("*"),
        }),

        -- Headers (h1-h3)
        s("h1", {
            t("# "),
            i(1, "Title"),
        }),
        s("h2", {
            t("## "),
            i(1, "Section"),
        }),
        s("h3", {
            t("### "),
            i(1, "Subsection"),
        }),

        -- Task checkbox
        s("task", {
            t("- [ ] "),
            i(1, "Task"),
        }),

        -- Markdown table
        s("table", {
            t({"| Column 1 | Column 2 | Column 3 |",
               "|----------|----------|----------|",
               "| "}),
            i(1, "data"),
            t(" | "),
            i(2, "data"),
            t(" | "),
            i(3, "data"),
            t(" |"),
        }),

        -- ====================================================================
        -- UNIVERSAL FRONTMATTER SNIPPET
        -- ====================================================================
        -- Trigger: Type "yaml-universal" and press Tab
        -- Creates comprehensive YAML frontmatter for Aethelred-Codex
        -- Compatible with ALL vault directories and DataViewJS queries
        --
        -- COVERS: Documents, Tasks, Projects, Operations, Research, etc.
        -- SPECIALIZED: Use "yaml-command" for command documentation
        --
        -- CRITICAL: Notice NO COMMAS after closing quotes!
        -- YAML uses newlines to separate fields, NOT commas
        -- ====================================================================
        s("yaml-universal", {
            t({"---",
               "document_uuid: \""}),
            -- Generate UUID v4
            f(function()
                math.randomseed(os.time() + os.clock() * 1000000)
                local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
                return template:gsub('[xy]', function(c)
                    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
                    return string.format('%x', v)
                end)
            end),
            t({"\"",           -- NO COMMA HERE!
               "id: \""}),
            f(function() return os.date("%Y") end),
            t("-"),
            i(1, "DOC"),       -- Type: DOC, TSK, PRJ, OPS, RUN, etc.
            t("-"),
            i(2, "001"),       -- Sequential number
            t({"\"",           -- NO COMMA!
               "title: \""}),
            i(3, "Document Title"),
            t({"\"",           -- NO COMMA!
               "description: \""}),
            i(4, "Brief description of purpose"),
            t({"\"",           -- NO COMMA!
               "category: \""}),
            i(5, "documentation"),  -- documentation, operational, project, personal, learning
            t({"\"",           -- NO COMMA!
               "subcategory: \""}),
            i(6, "general"),   -- More specific categorization
            t({"\"",           -- NO COMMA!
               "type: \""}),
            i(7, "document"),  -- document, task, project, command, runbook, etc.
            t({"\"",           -- NO COMMA!
               "status: \""}),
            i(8, "active"),    -- active, planning, in-progress, completed, on-hold, blocked
            t({"\"",           -- NO COMMA!
               "priority: \""}),
            i(9, "P2-Medium"), -- P0-Critical, P1-High, P2-Medium, P3-Low
            t({"\"",           -- NO COMMA!
               "version: \"1.0.0\"",    -- NO COMMA!
               "# Optional Fields (uncomment as needed)",
               "# progress: "}),
            i(10, "0"),        -- 0-100 percentage
            t({"",
               "# owner: \""}),
            i(11, "unassigned"),
            t({"\"",
               "# estimated_hours: "}),
            i(12, "0"),
            t({"",
               "# due_date: \"YYYY-MM-DD\"",
               "# parent_project: \"PROJECT-ID\"",
               "# assets_path: \"path/to/assets\"",
               "tags:",         -- Array starts
               "  - \""}),
            i(13, "tag1"),
            t({"\"",           -- NO COMMA after array item!
               "  - \""}),
            i(14, "tag2"),
            t({"\"",           -- NO COMMA!
               "date_created: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",           -- NO COMMA!
               "date_modified: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",           -- NO COMMA!
               "---",
               ""}),
        }),

        -- ====================================================================
        -- COMMAND ARSENAL FRONTMATTER
        -- ====================================================================
        -- Trigger: Type "yaml-command" and press Tab
        -- Creates detailed command documentation frontmatter
        -- Compatible with DataViewJS queries in Obsidian
        -- Includes: favorite, rating, success_rate, complexity, etc.
        -- ====================================================================
        s("yaml-command", {
            t({"---",
               "document_uuid: \""}),
            f(function()
                math.randomseed(os.time() + os.clock() * 1000000)
                local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
                return template:gsub('[xy]', function(c)
                    local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
                    return string.format('%x', v)
                end)
            end),
            t({"\"",
               "id: \""}),
            f(function() return os.date("%Y") end),
            t("-CMD-"),
            i(1, "001"),
            t({"\"",
               "title: \""}),
            i(2, "Command Title"),
            t({"\"",
               "description: \""}),
            i(3, "Brief description of what this command does"),
            t({"\"",
               "category: \""}),
            i(4, "system-admin"),
            t({"\"",
               "subcategory: \""}),
            i(5, "file-management"),
            t({"\"",
               "type: \"command\"",
               "# DataViewJS Critical Fields",
               "favorite: "}),
            i(6, "false"),                 -- Boolean, no quotes
            t({"",
               "personal_rating: "}),
            i(7, "3"),                      -- Number, no quotes
            t({"",
               "success_rate: "}),
            i(8, "0.95"),                   -- Number, no quotes
            t({"",
               "time_saved: \""}),
            i(9, "5-10 minutes"),
            t({"\"",
               "efficiency_gain: "}),
            i(10, "1.5"),                   -- Number, no quotes
            t({"",
               "times_used: 0",             -- Number, no quotes, no comma
               "complexity: \""}),
            i(11, "intermediate"),
            t({"\"",
               "platforms:",                -- Array starts
               "  - \""}),
            i(12, "linux"),
            t({"\"",
               "risk_level: \""}),
            i(13, "low"),
            t({"\"",
               "tested: true",              -- Boolean, no quotes, no comma
               "last_used: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",
               "tags:",
               "  - \"command\"",           -- Array item, no comma after quote
               "  - \""}),
            i(14, "category-tag"),
            t({"\"",
               "date_created: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",
               "date_modified: \""}),
            f(function() return os.date("%Y-%m-%d") end),
            t({"\"",
               "---",
               ""}),
        }),

        -- ====================================================================
        -- EMOJI SHORTCUTS
        -- ====================================================================
        -- Quick emoji insertion for documentation

        s("check", t("✅")),
        s("cross", t("❌")),
        s("warning", t("⚠️")),
        s("info", t("ℹ️")),
        s("fire", t("🔥")),
        s("rocket", t("🚀")),
        s("star", t("⭐")),
        s("bug", t("🐛")),
        s("boom", t("💥")),
        s("sparkles", t("✨")),
    })

    -- ========================================================================
    -- COMPLETION SETUP
    -- ========================================================================
    -- Note: Completion is now handled by blink.cmp (has built-in spell support)
    -- This section is preserved but disabled for nvim-cmp compatibility

    -- Optional: If you're using nvim-cmp instead of blink.cmp, uncomment below
    --[[
    local cmp_ok, cmp = pcall(require, 'cmp')
    if cmp_ok then
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown", "text", "gitcommit" },
            callback = function()
                cmp.setup.buffer {
                    sources = cmp.config.sources({
                        { name = 'nvim_lsp' },
                        { name = 'luasnip' },
                        { name = 'buffer' },
                        { name = 'path' },
                        { name = 'spell' },
                    }),
                }
            end,
        })
    end
    --]]
end

-- ============================================================================
-- MARKDOWN-SPECIFIC KEYBINDINGS
-- ============================================================================
-- Automatically activated when opening markdown files

function M.autocmds()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
            -- Set conceallevel for cleaner Obsidian UI
            -- Level 2 = hide markdown syntax (**, __, etc.)
            vim.opt_local.conceallevel = 2
            vim.opt_local.concealcursor = 'nc'  -- Keep concealing in normal/command mode

            local opts = { buffer = true, silent = true }

            -- ================================================================
            -- COMPREHENSIVE ABBREVIATIONS (150+) - Type + space to expand
            -- ================================================================
            -- Works alongside LuaSnip snippets (snippets use Tab, abbreviations use Space)

            local abbrev = vim.cmd

            -- Headers (h1-h6)
            abbrev([[iabbrev <buffer> h1 # ]])
            abbrev([[iabbrev <buffer> h2 ## ]])
            abbrev([[iabbrev <buffer> h3 ### ]])
            abbrev([[iabbrev <buffer> h4 #### ]])
            abbrev([[iabbrev <buffer> h5 ##### ]])
            abbrev([[iabbrev <buffer> h6 ###### ]])

            -- Todo/Tasks
            abbrev([[iabbrev <buffer> todo - [ ] ]])
            abbrev([[iabbrev <buffer> done - [x] ]])
            abbrev([[iabbrev <buffer> pending - [~] ]])
            abbrev([[iabbrev <buffer> cancelled - [-] ]])
            abbrev([[iabbrev <buffer> priority - [ ] **[P1]** ]])

            -- Lists
            abbrev([[iabbrev <buffer> ul - ]])
            abbrev([[iabbrev <buffer> ol 1. ]])
            abbrev([[iabbrev <buffer> task - [ ] ]])

            -- Code blocks (40+ languages)
            abbrev([[iabbrev <buffer> pycode ```python<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> jscode ```javascript<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> tscode ```typescript<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> shcode ```bash<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> luacode ```lua<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> rustcode ```rust<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> gocode ```go<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> ccode ```c<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> cppcode ```cpp<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> javacode ```java<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> csharpcode ```csharp<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> phpcode ```php<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> rubycode ```ruby<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> sqlcode ```sql<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> jsoncode ```json<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> yamlcode ```yaml<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> xmlcode ```xml<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> tomlcode ```toml<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> csvcode ```csv<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> htmlcode ```html<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> csscode ```css<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> scsscode ```scss<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> shellcode ```shell<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> console ```console<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> powershell ```powershell<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> cmdcode ```cmd<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> mdcode ```markdown<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> diffcode ```diff<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> gitcode ```git<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> dockercode ```dockerfile<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> makecode ```makefile<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> vimcode ```vim<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> regexcode ```regex<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> textcode ```text<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> plaincode ```plaintext<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> code ```<CR>```<Esc>O]])

            -- Callouts
            abbrev([[iabbrev <buffer> note > **Note:** ]])
            abbrev([[iabbrev <buffer> warn > **Warning:** ]])
            abbrev([[iabbrev <buffer> warning > **Warning:** ]])
            abbrev([[iabbrev <buffer> tip > **Tip:** ]])
            abbrev([[iabbrev <buffer> important > **Important:** ]])
            abbrev([[iabbrev <buffer> info > **Info:** ]])
            abbrev([[iabbrev <buffer> danger > **Danger:** ]])
            abbrev([[iabbrev <buffer> error > **Error:** ]])
            abbrev([[iabbrev <buffer> success > **Success:** ]])
            abbrev([[iabbrev <buffer> question > **Question:** ]])
            abbrev([[iabbrev <buffer> quote > ]])

            -- Date/Time stamps
            abbrev([[iabbrev <buffer> date <C-R>=strftime("%Y-%m-%d")<CR>]])
            abbrev([[iabbrev <buffer> time <C-R>=strftime("%H:%M")<CR>]])
            abbrev([[iabbrev <buffer> datetime <C-R>=strftime("%Y-%m-%d %H:%M")<CR>]])
            abbrev([[iabbrev <buffer> timestamp <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>]])

            -- Formatting
            abbrev([[iabbrev <buffer> bold ****<Left><Left>]])
            abbrev([[iabbrev <buffer> italic **<Left>]])
            abbrev([[iabbrev <buffer> strike ~~~~<Left><Left>]])
            abbrev([[iabbrev <buffer> inline `<BS>]])

            -- Links and references
            abbrev([[iabbrev <buffer> link [](https://)<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
            abbrev([[iabbrev <buffer> img ![](https://)<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]])
            abbrev([[iabbrev <buffer> ref [][]<Left><Left><Left>]])

            -- Table and elements
            abbrev([[iabbrev <buffer> table <Bar> Header 1 <Bar> Header 2 <Bar>]])
            abbrev([[iabbrev <buffer> hr ---]])

            -- Technical helpers
            abbrev([[iabbrev <buffer> TODO <!-- TODO: -->]])
            abbrev([[iabbrev <buffer> FIXME <!-- FIXME: -->]])
            abbrev([[iabbrev <buffer> NOTE <!-- NOTE: -->]])
            abbrev([[iabbrev <buffer> HACK <!-- HACK: -->]])
            abbrev([[iabbrev <buffer> XXX <!-- XXX: -->]])
            abbrev([[iabbrev <buffer> BUG <!-- BUG: -->]])
            abbrev([[iabbrev <buffer> DEPRECATED <!-- DEPRECATED: -->]])
            abbrev([[iabbrev <buffer> details <details><CR><summary></summary><CR><CR></details><Esc>2kA]])
            abbrev([[iabbrev <buffer> frontmatter ---<CR>title: <CR>date: <C-R>=strftime("%Y-%m-%d")<CR><CR>author: <CR>tags: []<CR>---<Esc>4kA]])
            abbrev([[iabbrev <buffer> apidoc ## API Documentation<CR><CR>### Endpoint<CR>```<CR>METHOD /path<CR>```<CR><CR>### Parameters<CR>- `name` (type, required): Description<CR><CR>### Response<CR>```json<CR>{<CR>}<CR>```<CR><CR>### Example<CR>```bash<CR>curl -X METHOD https://api.example.com/path<CR>```]])
            abbrev([[iabbrev <buffer> kbd <kbd></kbd><Left><Left><Left><Left><Left><Left>]])
            abbrev([[iabbrev <buffer> footnote [^1]<CR><CR>[^1]: ]])
            abbrev([[iabbrev <buffer> output **Output:**<CR>```<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> example **Example:**<CR>```<CR>```<Esc>O]])
            abbrev([[iabbrev <buffer> badge ![](https://img.shields.io/)]])
            abbrev([[iabbrev <buffer> toc ## Table of Contents<CR><CR>- []()<CR>- []()<CR>- []()]])

            -- Professional workflow templates
            abbrev([[iabbrev <buffer> meeting # Meeting Notes<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Attendees:** <CR><CR>## Agenda<CR>- [ ] <CR><CR>## Discussion<CR><CR>## Action Items<CR>- [ ] ]])
            abbrev([[iabbrev <buffer> daily # Daily Notes - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>## Tasks<CR>- [ ] <CR><CR>## Notes<CR><CR>## Tomorrow<CR>- [ ] ]])
            abbrev([[iabbrev <buffer> project # Project: <CR><CR>## Overview<CR><CR>## Goals<CR>- [ ] <CR><CR>## Timeline<CR><CR>## Resources<CR>]])
            abbrev([[iabbrev <buffer> weekly # Weekly Review - Week <C-R>=strftime("%U, %Y")<CR><CR><CR>## Accomplishments<CR>- <CR><CR>## Challenges<CR>- <CR><CR>## Next Week Goals<CR>- [ ] <CR><CR>## Notes<CR>]])
            abbrev([[iabbrev <buffer> weekplan # Weekly Plan - <C-R>=strftime("%Y-W%U")<CR><CR><CR>## This Week's Goals<CR>- [ ] <CR><CR>## Monday<CR>- [ ] <CR><CR>## Tuesday<CR>- [ ] <CR><CR>## Wednesday<CR>- [ ] <CR><CR>## Thursday<CR>- [ ] <CR><CR>## Friday<CR>- [ ] <CR><CR>## Weekend<CR>- [ ] ]])
            abbrev([[iabbrev <buffer> sprint # Sprint Planning - Sprint <CR><CR>**Duration:** <C-R>=strftime("%Y-%m-%d")<CR> to <CR>**Team:** <CR><CR>## Sprint Goal<CR><CR>## User Stories<CR>- [ ] **[Story]** As a ___ I want ___ so that ___<CR>  - **Acceptance Criteria:**<CR>  - **Estimate:** <CR><CR>## Tasks<CR>- [ ] <CR><CR>## Risks<CR>- ]])
            abbrev([[iabbrev <buffer> retro # Retrospective - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>## What Went Well 🎉<CR>- <CR><CR>## What Could Be Improved 🔧<CR>- <CR><CR>## Action Items<CR>- [ ] <CR><CR>## Appreciations 💙<CR>- ]])
            abbrev([[iabbrev <buffer> tutorial # Tutorial: <CR><CR>## Overview<CR>**Time:** ~X minutes<CR>**Level:** Beginner/Intermediate/Advanced<CR><CR>## Prerequisites<CR>- <CR><CR>## What You'll Learn<CR>- <CR><CR>## Steps<CR><CR>### Step 1: <CR><CR>### Step 2: <CR><CR>## Troubleshooting<CR><CR>## Next Steps<CR>]])
            abbrev([[iabbrev <buffer> howto # How to: <CR><CR>## Problem<CR><CR>## Solution<CR><CR>## Steps<CR><CR>1. <CR>2. <CR>3. <CR><CR>## Expected Result<CR><CR>## Common Issues<CR>]])
            abbrev([[iabbrev <buffer> docpage # Documentation: <CR><CR>## Description<CR><CR>## Usage<CR><CR>```<CR>```<CR><CR>## Parameters<CR>- `param1` (type, required): Description<CR><CR>## Examples<CR><CR>### Basic Example<CR>```<CR>```<CR><CR>### Advanced Example<CR>```<CR>```<CR><CR>## Notes<CR>]])
            abbrev([[iabbrev <buffer> changelog ## [Version] - <C-R>=strftime("%Y-%m-%d")<CR><CR><CR>### Added<CR>- <CR><CR>### Changed<CR>- <CR><CR>### Fixed<CR>- <CR><CR>### Removed<CR>- ]])
            abbrev([[iabbrev <buffer> release # Release Notes - v<CR><CR>**Release Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Highlights<CR>- <CR><CR>## New Features<CR>- <CR><CR>## Improvements<CR>- <CR><CR>## Bug Fixes<CR>- <CR><CR>## Breaking Changes<CR>- <CR><CR>## Upgrade Guide<CR>]])
            abbrev([[iabbrev <buffer> bugreport # Bug Report<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Severity:** Critical/High/Medium/Low<CR><CR>## Description<CR><CR>## Steps to Reproduce<CR>1. <CR>2. <CR>3. <CR><CR>## Expected Behavior<CR><CR>## Actual Behavior<CR><CR>## Environment<CR>- OS: <CR>- Version: <CR>- Browser: <CR><CR>## Logs/Screenshots<CR>```<CR>```<CR><CR>## Possible Solution<CR>]])
            abbrev([[iabbrev <buffer> feature # Feature Request<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Priority:** High/Medium/Low<CR><CR>## Problem Statement<CR>As a ___ I need ___ so that ___<CR><CR>## Proposed Solution<CR><CR>## Alternatives Considered<CR>- <CR><CR>## Acceptance Criteria<CR>- [ ] <CR><CR>## Technical Considerations<CR>- <CR><CR>## Effort Estimate<CR>]])
            abbrev([[iabbrev <buffer> adr # ADR: <CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Status:** Proposed/Accepted/Deprecated/Superseded<CR><CR>## Context<CR>What is the issue we're facing?<CR><CR>## Decision<CR>What are we doing about it?<CR><CR>## Consequences<CR>What becomes easier or harder?<CR><CR>### Positive<CR>- <CR><CR>### Negative<CR>- <CR><CR>### Risks<CR>- ]])
            abbrev([[iabbrev <buffer> codereview # Code Review - <C-R>=strftime("%Y-%m-%d")<CR><CR>**Reviewer:** <CR>**PR/Branch:** <CR><CR>## Summary<CR><CR>## ✅ Strengths<CR>- <CR><CR>## 🔧 Issues Found<CR>- [ ] <CR><CR>## 💡 Suggestions<CR>- <CR><CR>## 🧪 Testing Notes<CR>- [ ] Unit tests pass<CR>- [ ] Manual testing completed<CR>- [ ] Edge cases considered<CR><CR>## Decision<CR>- [ ] Approve<CR>- [ ] Request changes<CR>- [ ] Comment only]])
            abbrev([[iabbrev <buffer> design # Technical Design: <CR><CR>**Author:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Overview<CR><CR>## Goals<CR>- <CR><CR>## Non-Goals<CR>- <CR><CR>## Design<CR><CR>### Architecture<CR><CR>### Data Models<CR>```<CR>```<CR><CR>### API Design<CR>```<CR>```<CR><CR>## Alternatives Considered<CR><CR>## Security Considerations<CR><CR>## Performance Considerations<CR><CR>## Testing Strategy<CR><CR>## Rollout Plan<CR>1. <CR><CR>## Monitoring & Metrics<CR>]])
            abbrev([[iabbrev <buffer> postmortem # Incident Post-Mortem<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Incident Date:** <CR>**Duration:** <CR>**Severity:** <CR><CR>## Summary<CR><CR>## Timeline<CR>- **HH:MM** - <CR><CR>## Root Cause<CR><CR>## Impact<CR>- Users affected: <CR>- Systems affected: <CR><CR>## Resolution<CR><CR>## Action Items<CR>- [ ] **[P1]** <CR><CR>## Lessons Learned<CR><CR>### What Went Well<CR>- <CR><CR>### What Went Wrong<CR>- <CR><CR>### Where We Got Lucky<CR>- ]])
            abbrev([[iabbrev <buffer> classnotes # Class Notes - <C-R>=strftime("%Y-%m-%d")<CR><CR>**Course:** <CR>**Topic:** <CR>**Professor:** <CR><CR>## Key Concepts<CR>- <CR><CR>## Notes<CR><CR>## Examples<CR>```<CR>```<CR><CR>## Questions<CR>- [ ] <CR><CR>## Action Items<CR>- [ ] Read: <CR>- [ ] Practice: <CR>- [ ] Review: ]])
            abbrev([[iabbrev <buffer> studyguide # Study Guide: <CR><CR>**Exam Date:** <CR>**Topics Covered:** <CR><CR>## Key Concepts<CR><CR>### Concept 1<CR>**Definition:** <CR>**Example:** <CR>**Why it matters:** <CR><CR>## Formulas & Equations<CR>```<CR>```<CR><CR>## Practice Problems<CR>1. <CR><CR>## Study Checklist<CR>- [ ] Review lecture notes<CR>- [ ] Complete practice problems<CR>- [ ] Review homework<CR>- [ ] Create flashcards<CR>- [ ] Study group session]])
            abbrev([[iabbrev <buffer> research # Research Notes<CR><CR>**Topic:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Research Question<CR><CR>## Sources<CR>1. <CR><CR>## Key Findings<CR>- <CR><CR>## Quotes & Citations<CR>> <CR><CR>## My Analysis<CR><CR>## Next Steps<CR>- [ ] ]])
            abbrev([[iabbrev <buffer> assignment # Assignment: <CR><CR>**Course:** <CR>**Due Date:** <CR>**Points:** <CR><CR>## Requirements<CR>- [ ] <CR><CR>## Approach<CR><CR>## Notes<CR><CR>## Resources<CR>- <CR><CR>## Checklist Before Submission<CR>- [ ] Requirements met<CR>- [ ] Proofread<CR>- [ ] Citations formatted<CR>- [ ] Files named correctly<CR>- [ ] Submitted on time]])
            abbrev([[iabbrev <buffer> readingnotes # Reading Notes<CR><CR>**Title:** <CR>**Author:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Summary<CR><CR>## Key Points<CR>- <CR><CR>## Quotes<CR>> <CR><CR>## My Thoughts<CR><CR>## Questions<CR>- <CR><CR>## Action Items<CR>- [ ] ]])
            abbrev([[iabbrev <buffer> lesson # Lesson Plan<CR><CR>**Course:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Duration:** <CR>**Grade Level:** <CR><CR>## Learning Objectives<CR>Students will be able to:<CR>- <CR><CR>## Materials Needed<CR>- <CR><CR>## Introduction (X min)<CR><CR>## Main Activity (X min)<CR><CR>## Practice/Application (X min)<CR><CR>## Assessment<CR>- <CR><CR>## Homework/Follow-up<CR>- <CR><CR>## Notes/Reflections<CR>]])
            abbrev([[iabbrev <buffer> syllabus # Course Syllabus<CR><CR>**Course Title:** <CR>**Instructor:** <CR>**Term:** <CR>**Credits:** <CR><CR>## Course Description<CR><CR>## Learning Outcomes<CR>By the end of this course, students will be able to:<CR>1. <CR><CR>## Required Materials<CR>- <CR><CR>## Grading<CR>- Assignments: X%<CR>- Exams: X%<CR>- Participation: X%<CR>- Final Project: X%<CR><CR>## Schedule<CR><Bar> Week <Bar> Topic <Bar> Assignments <Bar><CR><CR>## Policies<CR><CR>### Attendance<CR><CR>### Late Work<CR><CR>### Academic Integrity<CR>]])
            abbrev([[iabbrev <buffer> rubric # Grading Rubric<CR><CR>**Assignment:** <CR>**Total Points:** <CR><CR><Bar> Criteria <Bar> Exemplary (A) <Bar> Proficient (B) <Bar> Developing (C) <Bar> Beginning (D/F) <Bar><CR><CR>## Comments<CR>]])
            abbrev([[iabbrev <buffer> feedback # Student Feedback<CR><CR>**Student:** <CR>**Assignment:** <CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Strengths<CR>- <CR><CR>## Areas for Growth<CR>- <CR><CR>## Specific Feedback<CR><CR>## Next Steps<CR>- [ ] <CR><CR>**Grade:** ]])
            abbrev([[iabbrev <buffer> brainstorm # Brainstorm: <CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## Problem/Goal<CR><CR>## Ideas<CR>- 💡 <CR><CR>## Best Ideas<CR>1. <CR><CR>## Next Actions<CR>- [ ] ]])
            abbrev([[iabbrev <buffer> problem # Problem Solving<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>## The Problem<CR><CR>## Why This Matters<CR><CR>## Possible Solutions<CR>1. <CR>   - Pros: <CR>   - Cons: <CR><CR>## Chosen Solution<CR><CR>## Action Plan<CR>- [ ] <CR><CR>## Results<CR>]])
            abbrev([[iabbrev <buffer> decision # Decision Log<CR><CR>**Date:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Decision:** <CR><CR>## Context<CR><CR>## Options Considered<CR>1. <CR><CR>## Decision Made<CR><CR>## Reasoning<CR><CR>## Expected Outcome<CR><CR>## Review Date<CR>]])
            abbrev([[iabbrev <buffer> booksummary # Book Summary<CR><CR>**Title:** <CR>**Author:** <CR>**Finished:** <C-R>=strftime("%Y-%m-%d")<CR><CR>**Rating:** ⭐⭐⭐⭐⭐<CR><CR>## Summary<CR><CR>## Key Takeaways<CR>1. <CR><CR>## Favorite Quotes<CR>> <CR><CR>## How I'll Apply This<CR>- [ ] <CR><CR>## Related Books<CR>- ]])
            abbrev([[iabbrev <buffer> goals # Goals - <C-R>=strftime("%Y")<CR><CR><CR>## Long-term Vision (5 years)<CR><CR>## This Year's Goals<CR><CR>### Career<CR>- [ ] <CR><CR>### Learning<CR>- [ ] <CR><CR>### Health<CR>- [ ] <CR><CR>### Personal<CR>- [ ] <CR><CR>## Quarterly Milestones<CR><CR>### Q1<CR>- [ ] <CR><CR>### Q2<CR>- [ ] <CR><CR>### Q3<CR>- [ ] <CR><CR>### Q4<CR>- [ ] ]])

            -- ================================================================
            -- AUTO-CONTINUATION FOR LISTS (Microsoft Word style)
            -- ================================================================
            -- Press Enter after list item → Creates another
            -- Press Enter on empty list item → Exits list

            vim.keymap.set("i", "<CR>", function()
                local line = vim.api.nvim_get_current_line()

                -- Check for checkbox patterns
                local checkbox_pattern = "^(%s*)%- %[.%] (.*)$"
                local checkbox_empty = "^(%s*)%- %[.%]%s*$"
                local indent, content = line:match(checkbox_pattern)

                if indent and content then
                    return "<CR>" .. indent .. "- [ ] "
                elseif line:match(checkbox_empty) then
                    return "<Esc>ddO"
                end

                -- Check for bullet list
                local bullet_pattern = "^(%s*)%- (.+)$"
                local bullet_empty = "^(%s*)%- %s*$"
                indent, content = line:match(bullet_pattern)

                if indent and content then
                    return "<CR>" .. indent .. "- "
                elseif line:match(bullet_empty) then
                    return "<Esc>ddO"
                end

                -- Check for numbered list
                local number_pattern = "^(%s*)(%d+)%. (.+)$"
                local number_empty = "^(%s*)(%d+)%. %s*$"
                local num
                indent, num, content = line:match(number_pattern)

                if indent and num and content then
                    local next_num = tonumber(num) + 1
                    return "<CR>" .. indent .. next_num .. ". "
                elseif line:match(number_empty) then
                    return "<Esc>ddO"
                end

                return "<CR>"
            end, { buffer = true, expr = true, desc = "Auto-continue lists and checkboxes" })

            -- ================================================================
            -- TEXT FORMATTING SHORTCUTS
            -- ================================================================
            -- Note: Requires vim-surround or similar plugin

            vim.keymap.set("n", "<leader>mb", "ysiw*", opts)      -- Bold word
            vim.keymap.set("v", "<leader>mb", "S*gvS*", opts)     -- Bold selection
            vim.keymap.set("n", "<leader>mi", "ysiw_", opts)      -- Italic word
            vim.keymap.set("v", "<leader>mi", "S_", opts)         -- Italic selection
            vim.keymap.set("n", "<leader>mc", "ysiw`", opts)      -- Code word
            vim.keymap.set("v", "<leader>mc", "S`", opts)         -- Code selection

            -- ================================================================
            -- HEADER INSERTION
            -- ================================================================

            vim.keymap.set("n", "<leader>m1", "I# <Esc>", opts)   -- Make H1
            vim.keymap.set("n", "<leader>m2", "I## <Esc>", opts)  -- Make H2
            vim.keymap.set("n", "<leader>m3", "I### <Esc>", opts) -- Make H3
            vim.keymap.set("n", "<leader>m4", "I#### <Esc>", opts)-- Make H4

            -- ================================================================
            -- LIST CREATION
            -- ================================================================

            vim.keymap.set("n", "<leader>ml", "I- <Esc>", opts)   -- Bullet list
            vim.keymap.set("n", "<leader>mn", "I1. <Esc>", opts)  -- Numbered list

            -- ================================================================
            -- TASK CHECKBOX MANAGEMENT
            -- ================================================================

            vim.keymap.set("n", "<leader>mt", "I- [ ] <Esc>", opts) -- Create checkbox
            vim.keymap.set("n", "<leader>md", "^f[lrx", opts)       -- Mark done ([ ] → [x])
            vim.keymap.set("n", "<leader>mu", "^f[lr ", opts)       -- Mark undone ([x] → [ ])

            -- ================================================================
            -- LIST INDENTATION (Tab/Shift+Tab in Insert Mode)
            -- ================================================================
            -- Smart Tab: Indents list items (bullets, numbers, checkboxes)
            -- Falls back to normal Tab behavior on non-list lines

            vim.keymap.set("i", "<Tab>", function()
                local line = vim.api.nvim_get_current_line()
                -- Check if line is a list item (bullet, numbered, or checkbox)
                if line:match("^%s*[-*+]%s") or line:match("^%s*%d+%.%s") or line:match("^%s*- %[.%]") then
                    return "<Esc>>>A"  -- Indent and return to insert mode at end of line
                else
                    return "<Tab>"     -- Normal tab behavior
                end
            end, { buffer = true, expr = true, silent = true, desc = "Indent list item or normal tab" })

            vim.keymap.set("i", "<S-Tab>", function()
                local line = vim.api.nvim_get_current_line()
                -- Check if line is a list item (bullet, numbered, or checkbox)
                if line:match("^%s*[-*+]%s") or line:match("^%s*%d+%.%s") or line:match("^%s*- %[.%]") then
                    return "<Esc><<A"  -- Outdent and return to insert mode at end of line
                else
                    return "<S-Tab>"   -- Normal shift-tab behavior
                end
            end, { buffer = true, expr = true, silent = true, desc = "Outdent list item or normal shift-tab" })

            -- ================================================================
            -- LINK CREATION
            -- ================================================================

            vim.keymap.set("v", "<leader>mk", "c[<C-r>\"]()<Esc>", opts) -- Make selection a link

            -- ================================================================
            -- TABLE INSERTION
            -- ================================================================

            vim.keymap.set("n", "<leader>mT",
                "i| Column 1 | Column 2 | Column 3 |<CR>|----------|----------|----------|<CR>| | | |<Esc>",
                opts)

            -- ================================================================
            -- VISUAL SELECTION TO TABLE CONVERTER
            -- ================================================================
            -- Keymap: <leader>mtt (visual mode)
            --
            -- WHAT IT DOES:
            -- Converts visually selected text into a markdown table.
            -- Perfect for when you paste data FIRST, then realize you need a table.
            --
            -- HOW IT WORKS:
            -- 1. Gets the visual selection range (start/end lines)
            -- 2. Reads the selected text
            -- 3. Auto-detects delimiter (tabs, commas, or spaces)
            -- 4. Splits each line into cells
            -- 5. Builds markdown table with header separator
            -- 6. Replaces selection with formatted table
            --
            -- WHEN TO USE:
            -- - You pasted ps aux output → select lines → <leader>mtt
            -- - You pasted Excel data → select it → <leader>mtt
            -- - Any multi-line tabular data that's already in your file
            --
            -- DIFFERENCE FROM table-paste SNIPPET:
            -- - table-paste: Data in clipboard → type trigger → instant table
            -- - <leader>mtt: Data already in file → select → convert
            --
            -- EXAMPLE:
            -- Before (select these lines):
            --   USER  PID   %CPU
            --   root  1     0.0
            --   evan  1234  2.3
            --
            -- After (<leader>mtt):
            --   | USER | PID  | %CPU |
            --   |------|------|------|
            --   | root | 1    | 0.0  |
            --   | evan | 1234 | 2.3  |
            --
            -- USAGE:
            -- 1. Paste data into markdown file
            -- 2. Visual select lines (V + arrow keys)
            -- 3. Press <leader>mtt
            -- 4. Done! Selected text becomes table
            -- ================================================================
            vim.keymap.set("v", "<leader>mtt", function()
                -- STEP 1: GET VISUAL SELECTION
                -- Get start and end line numbers of visual selection
                local start_line = vim.fn.line("'<")
                local end_line = vim.fn.line("'>")

                -- Read the selected lines from buffer
                local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

                if #lines == 0 then
                    vim.notify("No lines selected!", vim.log.levels.WARN)
                    return
                end

                -- STEP 2: DETECT DELIMITER
                -- Same logic as table-paste snippet
                local delimiter = '\t'  -- Default: tab-separated

                if not lines[1]:find('\t') then
                    if lines[1]:find(',') then
                        delimiter = ','  -- CSV data
                    else
                        delimiter = '%s%s+'  -- Space-separated (command output)
                    end
                end

                -- STEP 3: PARSE ALL ROWS
                local rows = {}
                local max_cols = 0

                for _, line in ipairs(lines) do
                    -- Split line by delimiter
                    local cells = vim.split(line, delimiter, { trimempty = false })

                    -- Trim whitespace from each cell
                    for j, cell in ipairs(cells) do
                        cells[j] = vim.trim(cell)
                    end

                    table.insert(rows, cells)
                    max_cols = math.max(max_cols, #cells)
                end

                -- STEP 4: BUILD MARKDOWN TABLE
                local result = {}

                for i, row in ipairs(rows) do
                    -- Pad with empty cells if needed
                    while #row < max_cols do
                        table.insert(row, '')
                    end

                    -- Build row: | cell1 | cell2 | cell3 |
                    local formatted_row = '| ' .. table.concat(row, ' | ') .. ' |'
                    table.insert(result, formatted_row)

                    -- Add separator after header (first row)
                    if i == 1 then
                        local separator_parts = {}
                        for _ = 1, max_cols do
                            table.insert(separator_parts, '-------')
                        end
                        local separator = '| ' .. table.concat(separator_parts, ' | ') .. ' |'
                        table.insert(result, separator)
                    end
                end

                -- STEP 5: REPLACE SELECTION WITH TABLE
                -- Replace the selected lines with our formatted table
                vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, result)

                vim.notify("✅ Converted " .. #lines .. " lines to markdown table!", vim.log.levels.INFO)
            end, { buffer = true, silent = true, desc = "Convert visual selection to markdown table" })

            -- ================================================================
            -- PREVIEW SHORTCUTS
            -- ================================================================

            vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", opts)     -- Start preview
            vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", opts) -- Stop preview

            -- ================================================================
            -- GLOW TERMINAL PREVIEW
            -- ================================================================
            -- If glow is installed, creates a beautiful terminal preview

            if vim.fn.executable('glow') == 1 then
                vim.keymap.set("n", "<leader>mg", function()
                    local filepath = vim.fn.expand('%:p')
                    vim.cmd('vnew | terminal glow ' .. filepath)
                    vim.cmd('setlocal nonumber norelativenumber')

                    -- Exit insert mode after a brief delay
                    vim.defer_fn(function()
                        vim.cmd('stopinsert')
                    end, 100)

                    -- Allow q and Esc to close the preview
                    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':bd!<CR>',
                        { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':bd!<CR>',
                        { noremap = true, silent = true })
                end, { buffer = true, desc = "Preview with Glow" })
            end
        end,
    })
end

-- ============================================================================
-- USER COMMANDS
-- ============================================================================
-- Commands available via :CommandName

function M.commands()

    -- ========================================================================
    -- GLOW PREVIEW COMMAND
    -- ========================================================================
    -- Creates a beautiful markdown preview in a terminal split

    if vim.fn.executable('glow') == 1 then
        vim.api.nvim_create_user_command('Glow', function()
            local filepath = vim.fn.expand('%:p')
            vim.cmd('vnew | terminal glow ' .. filepath)
            vim.cmd('setlocal nonumber norelativenumber')

            vim.defer_fn(function()
                vim.cmd('stopinsert')
                vim.notify("Glow Preview: Use j/k or Ctrl-D/Ctrl-U to scroll. Press q or Esc to close.",
                    vim.log.levels.INFO)
            end, 100)

            -- Set up keybindings to close the preview
            vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':bd!<CR>',
                { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', ':bd!<CR>',
                { noremap = true, silent = true })
        end, { desc = 'Preview markdown with Glow in split' })
    else
        -- If glow isn't installed, provide installation instructions
        vim.api.nvim_create_user_command('GlowInstall', function()
            vim.notify([[
Glow is not installed. Install it for terminal markdown rendering:

Windows:  scoop install glow
Mac:      brew install glow
Linux:    sudo snap install glow

Or download from: https://github.com/charmbracelet/glow/releases

After installing, restart Neovim to use :Glow command
]], vim.log.levels.INFO)
        end, { desc = 'Show Glow installation instructions' })
    end

    -- ========================================================================
    -- MARKDOWN CONCEALING TOGGLE
    -- ========================================================================
    -- Toggles whether markdown syntax is hidden (concealed) or shown

    vim.api.nvim_create_user_command('MarkdownConceal', function()
        if vim.wo.conceallevel == 0 then
            -- Enable concealing (hide syntax like ** and __)
            vim.wo.conceallevel = 2
            vim.wo.concealcursor = 'nc'
            vim.notify("Markdown concealing enabled (hides syntax)", vim.log.levels.INFO)
        else
            -- Disable concealing (show all syntax)
            vim.wo.conceallevel = 0
            vim.wo.concealcursor = ''
            vim.notify("Markdown concealing disabled (shows syntax)", vim.log.levels.INFO)
        end
    end, { desc = 'Toggle markdown syntax concealing' })

    -- ========================================================================
    -- OBSIDIAN FRONTMATTER VALIDATOR
    -- ========================================================================
    -- Checks if the current file has valid Aethelred-Codex frontmatter

    local function validate_obsidian_frontmatter()
        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
        local in_frontmatter = false

        -- Required fields for Aethelred-Codex
        local has_uuid = false
        local has_id = false
        local has_title = false
        local has_description = false
        local has_category = false
        local has_type = false
        local has_tags = false
        local tags_format_correct = true

        -- Scan the first 50 lines for frontmatter
        for i, line in ipairs(lines) do
            if line == "---" then
                if not in_frontmatter then
                    in_frontmatter = true
                else
                    break  -- End of frontmatter
                end
            elseif in_frontmatter then
                -- Check for required fields
                if line:match("^document_uuid:") then has_uuid = true end
                if line:match("^id:") then has_id = true end
                if line:match("^title:") then has_title = true end
                if line:match("^description:") then has_description = true end
                if line:match("^category:") then has_category = true end
                if line:match("^type:") then has_type = true end
                if line:match("^tags:") then has_tags = true end

                -- Check for incorrect inline array format
                if line:match("tags:%s*%[") then
                    tags_format_correct = false
                end
            end
        end

        -- Build list of missing fields
        local missing = {}
        if not has_uuid then table.insert(missing, "document_uuid") end
        if not has_id then table.insert(missing, "id") end
        if not has_title then table.insert(missing, "title") end
        if not has_description then table.insert(missing, "description") end
        if not has_category then table.insert(missing, "category") end
        if not has_type then table.insert(missing, "type") end
        if not has_tags then table.insert(missing, "tags") end

        -- Display results
        if #missing == 0 and tags_format_correct then
            vim.notify("✅ Obsidian frontmatter validation passed! Aethelred-Codex compliant.",
                vim.log.levels.INFO)
        else
            local message = "Obsidian Frontmatter Issues:\n\n"
            if #missing > 0 then
                message = message .. "❌ Missing fields: " .. table.concat(missing, ", ") .. "\n"
            end
            if not tags_format_correct then
                message = message .. "⚠️  Use YAML array format for tags (- \"tag\") not [tag]\n"
            end
            message = message .. "\n💡 Use 'frontmatter' snippet for compliant template."
            vim.notify(message, vim.log.levels.WARN)
        end
    end

    vim.api.nvim_create_user_command('ObsidianValidate', validate_obsidian_frontmatter,
        { desc = 'Validate Obsidian Aethelred-Codex frontmatter compliance' })

    -- ========================================================================
    -- PS AUX TO TABLE COMMAND
    -- ========================================================================
    -- Command: :PsTable
    --
    -- WHAT IT DOES:
    -- Runs `ps aux` command and inserts the output as a formatted markdown table
    -- at the current cursor position.
    --
    -- HOW IT WORKS:
    -- 1. Executes `ps aux` using vim.fn.systemlist()
    -- 2. Each line of output is parsed into cells (space-separated)
    -- 3. First line (header) gets special treatment
    -- 4. Builds markdown table with proper formatting
    -- 5. Inserts table at current cursor position
    --
    -- WHEN TO USE:
    -- - Documenting current running processes
    -- - Creating runbooks that need process info
    -- - Troubleshooting logs
    -- - System state documentation
    --
    -- DIFFERENCE FROM OTHER TABLE METHODS:
    -- - table-paste: Clipboard data → type snippet → table
    -- - <leader>mtt: Selected text → keymap → table
    -- - :PsTable: Runs command → auto-inserts table (no copy/paste!)
    --
    -- EXAMPLE OUTPUT:
    --   | USER | PID  | %CPU | %MEM | VSZ    | RSS   | TTY | STAT | START | TIME   | COMMAND     |
    --   |------|------|------|------|--------|-------|-----|------|-------|--------|-------------|
    --   | root | 1    | 0.0  | 0.1  | 168448 | 11904 | ?   | Ss   | 10:23 | 0:01   | /sbin/init  |
    --   | evan | 1234 | 2.3  | 1.5  | 523456 | 98304 | pts | Sl+  | 14:30 | 0:15   | nvim        |
    --
    -- USAGE:
    -- 1. Position cursor where you want the table
    -- 2. Type: :PsTable
    -- 3. Press Enter
    -- 4. Done! Process table inserted
    --
    -- EXTENSION IDEAS:
    -- You can easily create similar commands for other outputs:
    -- - :DfTable → df -h output
    -- - :LsTable → ls -la output
    -- - :NetstatTable → netstat -tulpn output
    -- Just copy this pattern and change the command!
    -- ========================================================================
    vim.api.nvim_create_user_command('PsTable', function()
        -- STEP 1: RUN PS AUX COMMAND
        -- systemlist() returns output as array of lines
        local output = vim.fn.systemlist('ps aux')

        if vim.v.shell_error ~= 0 then
            vim.notify("❌ Failed to run 'ps aux' command", vim.log.levels.ERROR)
            return
        end

        if #output == 0 then
            vim.notify("❌ No output from 'ps aux'", vim.log.levels.WARN)
            return
        end

        -- STEP 2: PARSE EACH LINE INTO CELLS
        local result = {}

        for i, line in ipairs(output) do
            -- Split by multiple spaces (ps aux output is space-separated)
            local cells = vim.split(line, '%s+', { trimempty = true })

            -- Trim whitespace from cells
            for j, cell in ipairs(cells) do
                cells[j] = vim.trim(cell)
            end

            -- Build markdown row
            local formatted_row = '| ' .. table.concat(cells, ' | ') .. ' |'
            table.insert(result, formatted_row)

            -- Add separator after header (first row)
            if i == 1 then
                local separator_parts = {}
                for _ = 1, #cells do
                    table.insert(separator_parts, '-------')
                end
                local separator = '| ' .. table.concat(separator_parts, ' | ') .. ' |'
                table.insert(result, separator)
            end
        end

        -- STEP 3: INSERT AT CURSOR POSITION
        -- Get current cursor row
        local row = vim.api.nvim_win_get_cursor(0)[1]

        -- Insert table at cursor (current row)
        vim.api.nvim_buf_set_lines(0, row, row, false, result)

        vim.notify("✅ Inserted process table (" .. #output .. " processes)", vim.log.levels.INFO)
    end, { desc = 'Insert ps aux output as markdown table at cursor' })
end

return M

-- ============================================================================
-- USAGE GUIDE
-- ============================================================================
--
-- HOW TO USE THIS MODULE IN YOUR CONFIG:
-- In your init.lua or plugin configuration:
--
--   local markdown = require("evanusmodestus.modules.plugins.markdown")
--   markdown.setup()      -- Sets up snippets and completion
--   markdown.autocmds()   -- Sets up markdown keybindings
--   markdown.commands()   -- Creates user commands
--
-- AVAILABLE SNIPPETS:
-- Basic Markdown:
--   code          → Code block with syntax highlighting
--   link          → Markdown link [text](url)
--   linkc         → Link with clipboard URL (cursor in text field)
--   img           → Image embed ![alt](url)
--   bold          → **bold text**
--   italic        → *italic text*
--   h1/h2/h3      → Headers
--   task          → - [ ] checkbox
--   table         → Markdown table
--
-- Frontmatter Templates (type "yaml-" to see all):
--   yaml-universal   → Universal frontmatter (documents, tasks, projects, operations)
--                      Includes: uuid, id, title, description, category, subcategory,
--                      type, status, priority, version, optional fields (progress,
--                      owner, estimated_hours, due_date, parent_project, assets_path)
--   yaml-command     → Command documentation with tracking fields
--                      Includes: favorite, personal_rating, success_rate, times_used,
--                      complexity, platforms, risk_level, time_saved, etc.
--
-- Emojis:
--   check/cross/warning/info/fire/rocket/star/bug/boom/sparkles
--
-- KEYBINDINGS (Markdown files only):
--   <leader>mb/mi/mc → Bold/Italic/Code
--   <leader>m1-4     → Headers H1-H4
--   <leader>ml/mn    → Bullet/Numbered list
--   <leader>mt/md/mu → Task checkbox (create/done/undone)
--   <leader>mk       → Make selection a link
--   <leader>mT       → Insert table
--   <leader>mp/ms    → Preview start/stop
--   <leader>mg       → Glow preview (if installed)
--
-- COMMANDS:
--   :Glow              → Preview with Glow
--   :GlowInstall       → Show installation instructions
--   :MarkdownConceal   → Toggle syntax concealing
--   :ObsidianValidate  → Validate frontmatter
--
-- YAML REMINDER:
-- NO COMMAS after field values! YAML uses newlines, not commas.
-- ✅ Correct:   title: "My Title"
-- ❌ Wrong:     title: "My Title",
--
-- ============================================================================
