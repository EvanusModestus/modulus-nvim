-- ============================================================================
-- FILE: obsidian-capture.lua
-- PURPOSE: Interactive capture system with wizards for Aethelred-Codex
-- LOCATION: ~/neovim-config/lua/evanusmodestus/modules/plugins/obsidian-capture.lua
-- ============================================================================

local M = {}

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

-- ============================================================================
-- IMPORTANT: Obsidian Vault Configuration
-- ============================================================================
-- This plugin requires an Obsidian vault to function.
-- To use this feature:
-- 1. Update 'vault_path' below to point to your Obsidian vault
-- 2. Customize the 'paths' structure to match your vault's folder layout
--
-- If the vault path doesn't exist, all Obsidian capture commands will be
-- gracefully disabled and the plugin will not load.
-- ============================================================================

local config = {
    vault_path = vim.fn.expand('~/Aethelred-Codex'),  -- ⚠️ CHANGE THIS to your vault path
    paths = {
        codex = 'The_Codex',
        projects = 'The_Codex/06_Projects',
        tasks = 'The_Codex/06_Projects/06_TASKS',
        incidents = 'The_Codex/07_Tabularium/04_INCIDENT_RESPONSE',
        solutions = 'The_Codex/07_Tabularium/05_QUICK_SOLUTIONS',
        ideas = 'The_Codex/07_Tabularium/03_IDEAS_INSIGHTS',
        rca = 'The_Codex/07_Tabularium/04_INCIDENT_RESPONSE/RCA',
        command_arsenal = 'The_Codex/_command_arsenal',
        assets = 'The_Codex/12_Assets/06_PROJECT_ASSETS',
        operations = 'The_Codex/05_Operations',
        runbooks = 'The_Codex/05_Operations/RUNBOOKS',
        change_requests = 'The_Codex/05_Operations/11_CHANGE_REQUESTS',
        oncall_logs = 'The_Codex/05_Operations/ONCALL_LOGS',
        learning = 'The_Codex/07_Tabularium/03_IDEAS_INSIGHTS/LEARNING',
        network_diagrams = 'The_Codex/04_Foundry/NETWORK_DIAGRAMS',
    },
    notifications = {
        enabled = true,
        level = vim.log.levels.INFO,
    }
}

-- Check if vault exists; if not, disable the plugin gracefully
if vim.fn.isdirectory(config.vault_path) == 0 then
    -- Vault doesn't exist, return a stub module that does nothing
    return {
        setup = function()
            -- Silently skip setup
        end,
        keymaps = function()
            -- Silently skip keymaps
        end
    }
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function generate_uuid()
    math.randomseed(os.time() + os.clock() * 1000000)
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return template:gsub('[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function sanitize_filename(str)
    return str:gsub('[^%w%s-]', ''):gsub('%s+', '-'):lower()
end

local function ensure_directory(path)
    local success = vim.fn.mkdir(path, 'p')

    if success == 0 then
        vim.notify('Failed to create directory: ' .. path, vim.log.levels.ERROR)
        return false
    end
    return true
end

local function write_file(filepath, content)
    local file = io.open(filepath, 'w')
    if file then
        file:write(content)
        file:close()
        return true
    end
    return false
end

local function notify(message, level)
    if config.notifications.enabled then
        vim.notify(message, level or config.notifications.level)
    end
end

local function validate_input(value, field_name)
    if not value or value == '' then
        notify(string.format('Error: %s cannot be empty', field_name), vim.log.levels.ERROR)
        return false
    end
    return true
end

-- ============================================================================
-- ORIGINAL CAPTURE FUNCTIONS
-- ============================================================================

local function capture_incident()
    local vault_path = config.vault_path
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'Incident Number (e.g., 001): ' }, function(inc_num)
        if not validate_input(inc_num, 'Incident Number') then return end

        vim.ui.input({ prompt = 'Incident Title: ' }, function(title)
            if not validate_input(title, 'Incident Title') then return end

            vim.ui.select(
                { 'P1', 'P2', 'P3', 'P4' },
                { prompt = 'Select Severity:' },
                function(severity)
                    if not severity then return end

                    vim.ui.input({ prompt = 'Brief Description: ' }, function(description)
                        if not validate_input(description, 'Description') then return end

                        local filename = string.format('INC-%s-%s.md', date, inc_num)
                        local filepath = string.format('%s/%s/%s', vault_path, config.paths.incidents, filename)

                        local content = string.format([[---
document_uuid: "%s"
id: "INC-%s-%s"
title: "%s"
description: "%s"
category: "incident_response"
type: "incident"
severity: "%s"
status: "investigating"
tags:
  - "incident"
  - "post-mortem"
date_created: "%s"
date_modified: "%s"
---

# 🚨 Incident Post-Mortem: INC-%s-%s

## Executive Summary

**Incident ID**: INC-%s-%s
**Severity**: %s
**Duration**: [Start] - [End] ([Total time])
**Impact**: %s
**Status**: Investigating

## Timeline

| Time (UTC) | Event | Actor | Action |
|------------|-------|-------|--------|
| %s | Alert triggered | Monitoring | [Details] |

## Impact Analysis

- **Users Affected**: [Number or percentage]
- **Services Impacted**: [List services]
- **Data Loss**: None
- **SLA Status**: [Met/Breached]

## Root Cause Analysis

### What Happened?

[Detailed description]

### Why Did It Happen?

**Root Cause**: [Primary cause]

**Contributing Factors**:
1. [Factor 1]
2. [Factor 2]

## Action Items

- [ ] Immediate fix
- [ ] Long-term solution
- [ ] Documentation update

## Lessons Learned

[What we learned from this incident]
]],
                            generate_uuid(),
                            date, inc_num,
                            title,
                            description,
                            severity,
                            date,
                            date,
                            date, inc_num,
                            date, inc_num,
                            severity,
                            description,
                            os.date('%H:%M')
                        )

                        local dir_path = string.format('%s/%s', vault_path, config.paths.incidents)
                        if not ensure_directory(dir_path) then return end

                        if write_file(filepath, content) then
                            vim.cmd('edit ' .. filepath)
                            notify(string.format('✅ Created incident: %s', filename))
                        else
                            notify('❌ Failed to create incident file', vim.log.levels.ERROR)
                        end
                    end)
                end
            )
        end)
    end)
end

local function capture_solution()
    local vault_path = config.vault_path
    local date = os.date('%Y-%m-%d')
    local year = os.date('%Y')

    vim.ui.input({ prompt = 'Solution Number (e.g., 001): ' }, function(sol_num)
        if not validate_input(sol_num, 'Solution Number') then return end

        vim.ui.input({ prompt = 'Solution Title: ' }, function(title)
            if not validate_input(title, 'Solution Title') then return end

            vim.ui.input({ prompt = 'Problem Description: ' }, function(problem)
                if not validate_input(problem, 'Problem Description') then return end

                local filename = string.format('QSL-%s-%s.md', year, sol_num)
                local filepath = string.format('%s/%s/%s', vault_path, config.paths.solutions, filename)

                local content = string.format([[---
document_uuid: "%s"
id: "QSL-%s-%s"
title: "%s"
type: "solution"
category: "troubleshooting"
tags:
  - "solution"
  - "troubleshooting"
date_created: "%s"
date_modified: "%s"
---

# 🔧 %s

## Problem

%s

## Solution

[Describe the solution]

## Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

## Verification

- [ ] Test the solution
- [ ] Document results
- [ ] Update runbook

## Related

- Related commands:
- Related incidents:
]],
                    generate_uuid(),
                    year, sol_num,
                    title,
                    date,
                    date,
                    title,
                    problem
                )

                local dir_path = string.format('%s/%s', vault_path, config.paths.solutions)
                if not ensure_directory(dir_path) then return end

                if write_file(filepath, content) then
                    vim.cmd('edit ' .. filepath)
                    notify(string.format('✅ Created solution: %s', filename))
                else
                    notify('❌ Failed to create solution file', vim.log.levels.ERROR)
                end
            end)
        end)
    end)
end

local function capture_command()
    local vault_path = config.vault_path
    local year = os.date('%Y')

    local categories = {
        '00_META', '01_DAILY_OPERATIONS', '02_FILE_MANAGEMENT', '03_SYSTEM_ADMIN',
        '04_CLOUD_PLATFORMS', '05_CONTAINER_ECOSYSTEM', '06_NETWORKING',
        '07_SECURITY', '08_DEVELOPMENT', '09_DATA_ANALYTICS', '10_DEVOPS_CI_CD',
        '11_MONITORING', '12_BACKUP_RECOVERY', '13_AUTOMATION', '14_KUBERNETES',
        '15_DATABASES', '16_TROUBLESHOOTING', '17_INCIDENT_RESPONSE'
    }

    vim.ui.select(
        categories,
        { prompt = 'Select Command Category:' },
        function(category)
            if not category then return end

            vim.ui.input({ prompt = 'Command Number (e.g., 001): ' }, function(cmd_num)
                if not validate_input(cmd_num, 'Command Number') then return end

                vim.ui.input({ prompt = 'Command Title: ' }, function(title)
                    if not validate_input(title, 'Command Title') then return end

                    vim.ui.input({ prompt = 'Brief Description: ' }, function(description)
                        if not validate_input(description, 'Description') then return end

                        local filename = string.format('%s-CMD-%s.md', year, cmd_num)
                        local filepath = string.format('%s/%s/%s/%s',
                            vault_path, config.paths.command_arsenal, category, filename)

                        local content = string.format([[---
document_uuid: "%s"
id: "%s-CMD-%s"
title: "%s"
description: "%s"
category: "command"
type: "command"
complexity: "intermediate"
platforms: ["linux"]
tags:
  - "command"
date_created: "%s"
date_modified: "%s"
personal_rating: 5
success_rate: 0.95
risk_level: "low"
---

# %s

## 🎯 Quick Reference

```bash
# [Your command here]
```

## 📝 Description

%s

## 🚀 Basic Usage

### Syntax
```bash
# [Command structure]
```

### Simple Example
```bash
# [Working example]

# Expected output:
# [Show output]
```

## 💡 Common Use Cases

### Use Case 1: [Scenario]
```bash
# [Command for this case]
```

## ⚙️ Parameters & Options

| Parameter | Description | Required | Default | Example |
|-----------|-------------|----------|---------|---------|
| `[param]` | [Description] | Yes/No | [value] | `[example]` |

## 📝 Personal Notes

- **When I Use This**: [Your use cases]
- **Lessons Learned**: [What you've learned]
]],
                            generate_uuid(),
                            year, cmd_num,
                            title,
                            description,
                            os.date('%Y-%m-%d'),
                            os.date('%Y-%m-%d'),
                            title,
                            description
                        )

                        local dir_path = string.format('%s/%s/%s',
                            vault_path, config.paths.command_arsenal, category)
                        if not ensure_directory(dir_path) then return end

                        if write_file(filepath, content) then
                            vim.cmd('edit ' .. filepath)
                            notify(string.format('✅ Created command: %s', filename))
                        else
                            notify('❌ Failed to create command file', vim.log.levels.ERROR)
                        end
                    end)
                end)
            end)
        end
    )
end

local function capture_task()
    local vault_path = config.vault_path
    local year = os.date('%Y')
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'Task Number (e.g., 001): ' }, function(task_num)
        if not validate_input(task_num, 'Task Number') then return end

        vim.ui.input({ prompt = 'Task Title: ' }, function(title)
            if not validate_input(title, 'Task Title') then return end

            vim.ui.select(
                { 'high', 'medium', 'low' },
                { prompt = 'Select Priority:' },
                function(priority)
                    if not priority then return end

                    vim.ui.input({ prompt = 'Due Date (YYYY-MM-DD): ' }, function(due_date)
                        if not validate_input(due_date, 'Due Date') then return end

                        local filename = string.format('TASK-%s-%s.md', year, task_num)
                        local filepath = string.format('%s/%s/%s', vault_path, config.paths.tasks, filename)

                        local content = string.format([[---
document_uuid: "%s"
id: "TASK-%s-%s"
title: "%s"
category: "tasks"
type: "task"
status: "todo"
priority: "%s"
due_date: "%s"
tags:
  - "task"
date_created: "%s"
---

# %s

## 📋 Task Details

[Detailed description of the task]

## ✅ Checklist

- [ ] Subtask 1
- [ ] Subtask 2
- [ ] Subtask 3

## 📝 Notes

[Additional notes and context]
]],
                            generate_uuid(),
                            year, task_num,
                            title,
                            priority,
                            due_date,
                            date,
                            title
                        )

                        local dir_path = string.format('%s/%s', vault_path, config.paths.tasks)
                        if not ensure_directory(dir_path) then return end

                        if write_file(filepath, content) then
                            vim.cmd('edit ' .. filepath)
                            notify(string.format('✅ Created task: %s', filename))
                        else
                            notify('❌ Failed to create task file', vim.log.levels.ERROR)
                        end
                    end)
                end
            )
        end)
    end)
end

local function capture_idea()
    local vault_path = config.vault_path
    local year = os.date('%Y')
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'Idea Number (e.g., 001): ' }, function(idea_num)
        if not validate_input(idea_num, 'Idea Number') then return end

        vim.ui.input({ prompt = 'Idea Title: ' }, function(title)
            if not validate_input(title, 'Idea Title') then return end

            local filename = string.format('IDEA-%s-%s.md', year, idea_num)
            local filepath = string.format('%s/%s/%s', vault_path, config.paths.ideas, filename)

            local content = string.format([[---
document_uuid: "%s"
id: "IDEA-%s-%s"
title: "%s"
type: "idea"
status: "captured"
tags: ["idea"]
date_created: "%s"
---

# 💡 %s

## The Idea

[Describe your idea in detail]

## Potential Value

- [What problem does this solve?]
- [What benefits does it provide?]

## Next Steps

- [ ] Research feasibility
- [ ] Create proof of concept
- [ ] Validate with stakeholders

## Related

- Related projects:
- Similar ideas:
]],
                generate_uuid(),
                year, idea_num,
                title,
                date,
                title
            )

            local dir_path = string.format('%s/%s', vault_path, config.paths.ideas)
            if not ensure_directory(dir_path) then return end

            if write_file(filepath, content) then
                vim.cmd('edit ' .. filepath)
                notify(string.format('✅ Created idea: %s', filename))
            else
                notify('❌ Failed to create idea file', vim.log.levels.ERROR)
            end
        end)
    end)
end

local function capture_rca()
    local vault_path = config.vault_path
    local year = os.date('%Y')
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'RCA Number (e.g., 001): ' }, function(rca_num)
        if not validate_input(rca_num, 'RCA Number') then return end

        vim.ui.input({ prompt = 'RCA Title: ' }, function(title)
            if not validate_input(title, 'RCA Title') then return end

            vim.ui.input({ prompt = 'Incident ID (if related, or press Enter to skip): ' }, function(incident_id)
                local filename = string.format('RCA-%s-%s.md', year, rca_num)
                local filepath = string.format('%s/%s/%s', vault_path, config.paths.rca, filename)

                local content = string.format([[---
document_uuid: "%s"
id: "RCA-%s-%s"
title: "%s"
type: "analysis"
category: "incident_response"
related_incident: "%s"
tags:
  - "rca"
  - "root-cause"
  - "analysis"
date_created: "%s"
---

# 🔍 Root Cause Analysis: %s

## Problem Statement

[Clear description of the problem that occurred]

## Five Whys Analysis

1. **Why did the problem occur?**
   - [First-level cause]

2. **Why did that happen?**
   - [Second-level cause]

3. **Why did that happen?**
   - [Third-level cause]

4. **Why did that happen?**
   - [Fourth-level cause]

5. **Why did that happen?**
   - [Root cause]

## Root Cause

**Primary Root Cause**: [The fundamental reason]

## Contributing Factors

1. [Factor 1]
2. [Factor 2]
3. [Factor 3]

## Corrective Actions

### Immediate Actions
- [ ] [Action 1]
- [ ] [Action 2]

### Long-term Actions
- [ ] [Action 1]
- [ ] [Action 2]

## Prevention

How do we prevent this from happening again?

1. [Prevention measure 1]
2. [Prevention measure 2]

## Related Incidents

- Related to: %s
]],
                    generate_uuid(),
                    year, rca_num,
                    title,
                    incident_id or 'None',
                    date,
                    title,
                    incident_id or 'None'
                )

                local dir_path = string.format('%s/%s', vault_path, config.paths.rca)
                if not ensure_directory(dir_path) then return end

                if write_file(filepath, content) then
                    vim.cmd('edit ' .. filepath)
                    notify(string.format('✅ Created RCA: %s', filename))
                else
                    notify('❌ Failed to create RCA file', vim.log.levels.ERROR)
                end
            end)
        end)
    end)
end

local function capture_project()
    local vault_path = config.vault_path
    local year = os.date('%Y')
    local date = os.date('%Y-%m-%d')

    local domains = {
        'Infrastructure', 'ISE', 'DevOps', 'Cloud', 'Security',
        'Data', 'AI/ML', 'Web', 'Mobile', 'Research', 'Operations', 'Documentation'
    }

    local domain_codes = {
        Infrastructure = 'INF',
        ISE = 'ISE',
        DevOps = 'DEV',
        Cloud = 'CLD',
        Security = 'SEC',
        Data = 'DAT',
        ['AI/ML'] = 'AML',
        Web = 'WEB',
        Mobile = 'MOB',
        Research = 'RES',
        Operations = 'OPS',
        Documentation = 'DOC'
    }

    vim.ui.select(
        domains,
        { prompt = 'Select Project Domain:' },
        function(domain)
            if not domain then return end
            local domain_code = domain_codes[domain]

            vim.ui.input({ prompt = 'Project Number (e.g., 001): ' }, function(proj_num)
                if not validate_input(proj_num, 'Project Number') then return end

                vim.ui.input({ prompt = 'Project Title: ' }, function(title)
                    if not validate_input(title, 'Project Title') then return end

                    vim.ui.input({ prompt = 'Project Description: ' }, function(description)
                        if not validate_input(description, 'Description') then return end

                        vim.ui.select(
                            { 'planning', 'active', 'on-hold', 'completed' },
                            { prompt = 'Project Status:' },
                            function(status)
                                if not status then return end

                                vim.ui.select(
                                    { 'high', 'medium', 'low' },
                                    { prompt = 'Priority:' },
                                    function(priority)
                                        if not priority then return end

                                        local project_id = string.format('%s-PRJ-%s', year, proj_num)
                                        local project_uuid = generate_uuid()
                                        local safe_title = sanitize_filename(title)

                                        local filename = string.format('%s-%s.md', project_id, safe_title)
                                        local filepath = string.format('%s/%s/%s',
                                            vault_path, config.paths.projects, filename)

                                        local asset_base = string.format('%s/%s/%s-%s',
                                            vault_path, config.paths.assets, project_id, safe_title)

                                        local asset_dirs = {
                                            'diagrams', 'scripts', 'configs', 'docs', 'logs', 'data', 'archives'
                                        }

                                        ensure_directory(asset_base)
                                        for _, dir in ipairs(asset_dirs) do
                                            ensure_directory(asset_base .. '/' .. dir)
                                        end

                                        local metadata = string.format([[{
  "project_id": "%s",
  "project_uuid": "%s",
  "title": "%s",
  "description": "%s",
  "domain": "%s",
  "status": "%s",
  "priority": "%s",
  "created": "%s",
  "asset_path": "%s/%s-%s"
}
]],
                                            project_id, project_uuid, title, description,
                                            domain, status, priority, date,
                                            config.paths.assets, project_id, safe_title)

                                        write_file(asset_base .. '/PROJECT_METADATA.json', metadata)

                                        local content = string.format([[---
document_uuid: "%s"
project_uuid: "%s"
id: "%s"
title: "%s"
category: "projects"
type: "project"
status: "%s"
priority: "%s"
progress: 0
domain: "%s"
health: "GREEN"
tags:
  - "project"
  - "%s"
assets_path: "%s/%s-%s"
date_created: "%s"
date_modified: "%s"
---

# %s

## 📋 Project Overview

%s

## 🎯 Business Impact

- **Value**: [Define business value]
- **Risk Reduction**: [Risks mitigated]
- **Compliance**: [Compliance requirements]

## ⚡ Current Status (0%% Complete)

### Phase 1: Planning
- [ ] Requirements gathering
- [ ] Stakeholder alignment
- [ ] Resource allocation

### Phase 2: Implementation
- [ ] Initial setup
- [ ] Core functionality
- [ ] Testing

### Phase 3: Deployment
- [ ] Production readiness
- [ ] Rollout plan
- [ ] Go-live

## 🛠️ Technical Architecture

### Technology Stack
- **Domain**: %s
- **Primary Tech**: [Technology stack]

### Architecture Diagram
```mermaid
graph LR
    A[Component 1] --> B[Component 2]
    B --> C[Component 3]
```

## 📊 Success Metrics

### KPIs
- **Metric 1**: Target value
- **Metric 2**: Target value

## 📁 Project Assets

All project assets are in: `%s-%s/`

### Asset Structure
- `/diagrams/` - Architecture and visual diagrams
- `/scripts/` - Automation scripts
- `/configs/` - Configuration files
- `/docs/` - Additional documentation
- `/logs/` - Change and deployment logs
- `/data/` - Data files
- `/archives/` - Old versions and backups

## 📝 Notes

[Additional project notes]
]],
                                            project_uuid,
                                            project_uuid,
                                            project_id,
                                            title,
                                            status,
                                            priority,
                                            domain,
                                            domain:lower(),
                                            config.paths.assets, project_id, safe_title,
                                            date,
                                            date,
                                            title,
                                            description,
                                            domain,
                                            project_id, safe_title
                                        )

                                        local dir_path = string.format('%s/%s', vault_path, config.paths.projects)
                                        if not ensure_directory(dir_path) then return end

                                        if write_file(filepath, content) then
                                            vim.cmd('edit ' .. filepath)
                                            notify(string.format('✅ Created project: %s\n📁 Assets: %s-%s/',
                                                filename, project_id, safe_title))
                                        else
                                            notify('❌ Failed to create project file', vim.log.levels.ERROR)
                                        end
                                    end
                                )
                            end
                        )
                    end)
                end)
            end)
        end
    )
end

-- ============================================================================
-- NEW CAPTURE FUNCTIONS
-- ============================================================================

local function capture_runbook()
    local vault_path = config.vault_path
    local year = os.date('%Y')
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'Runbook Number (e.g., 001): ' }, function(run_num)
        if not validate_input(run_num, 'Runbook Number') then return end

        vim.ui.input({ prompt = 'Procedure Title: ' }, function(title)
            if not validate_input(title, 'Title') then return end

            vim.ui.input({ prompt = 'System (e.g., ISE, Network, Azure): ' }, function(system)
                if not validate_input(system, 'System') then return end

                vim.ui.select(
                    { 'high', 'medium', 'low' },
                    { prompt = 'Select Criticality:' },
                    function(criticality)
                        if not criticality then return end

                        local filename = string.format('RUN-%s-%s.md', year, run_num)
                        local filepath = string.format('%s/%s/%s', vault_path, config.paths.runbooks, filename)

                        local content = string.format([[---
document_uuid: "%s"
id: "RUN-%s-%s"
title: "%s"
type: "runbook"
category: "operations"
system: "%s"
criticality: "%s"
estimated_time: "30 minutes"
tags:
  - "runbook"
  - "operations"
date_created: "%s"
---

# 📖 Runbook: %s

## 🎯 Purpose

[What this procedure accomplishes]

## ⚠️ Prerequisites

- [ ] Access credentials
- [ ] VPN connection
- [ ] Required tools installed

## 📋 Procedure

### Step 1: Initial Setup
```bash
# Commands here
```

**Expected Result:** [What you should see]

### Step 2: Main Operation
```bash
# Commands here
```

**Expected Result:** [What you should see]

## 🔄 Rollback Procedure

If something goes wrong:

1. [Rollback step 1]
2. [Rollback step 2]

## ✅ Verification

- [ ] Verify system is functioning
- [ ] Check logs for errors
- [ ] Confirm with monitoring

## 📞 Escalation

- **Contact:** [Team/person to contact]
- **On-Call:** [Pager/phone number]

## 📝 Notes

[Additional context and gotchas]
]],
                            generate_uuid(),
                            year, run_num,
                            title,
                            system,
                            criticality,
                            date,
                            title
                        )

                        local dir_path = string.format('%s/%s', vault_path, config.paths.runbooks)
                        if not ensure_directory(dir_path) then return end

                        if write_file(filepath, content) then
                            vim.cmd('edit ' .. filepath)
                            notify(string.format('✅ Created runbook: %s', filename))
                        else
                            notify('❌ Failed to create runbook file', vim.log.levels.ERROR)
                        end
                    end
                )
            end)
        end)
    end)
end

local function capture_change_request()
    local vault_path = config.vault_path
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'Change Number (e.g., 001): ' }, function(chg_num)
        if not validate_input(chg_num, 'Change Number') then return end

        vim.ui.input({ prompt = 'Change Title: ' }, function(title)
            if not validate_input(title, 'Title') then return end

            vim.ui.select(
                { 'low', 'medium', 'high' },
                { prompt = 'Risk Level:' },
                function(risk)
                    if not risk then return end

                    vim.ui.select(
                        { 'low', 'medium', 'high' },
                        { prompt = 'Impact Level:' },
                        function(impact)
                            if not impact then return end

                            local filename = string.format('CHG-%s-%s.md', date, chg_num)
                            local filepath = string.format('%s/%s/%s',
                                vault_path, config.paths.change_requests, filename)

                            local content = string.format([[---
document_uuid: "%s"
id: "CHG-%s-%s"
title: "%s"
type: "change-request"
status: "pending"
risk: "%s"
impact: "%s"
change_window: "TBD"
approver: "TBD"
tags:
  - "change-management"
date_created: "%s"
---

# 🔄 Change Request: CHG-%s-%s

## 📝 Change Summary

[What is being changed and why]

## 🎯 Business Justification

[Why this change is necessary]

## 🛠️ Implementation Plan

### Pre-Change Tasks
- [ ] Backup current config
- [ ] Notify stakeholders
- [ ] Schedule maintenance window

### Change Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Post-Change Verification
- [ ] Verify functionality
- [ ] Check monitoring
- [ ] Confirm with stakeholders

## 🔙 Rollback Plan

[How to revert if needed]

## 📊 Risk Assessment

- **Likelihood:** [Low/Medium/High]
- **Impact:** [Low/Medium/High]
- **Mitigation:** [How to reduce risk]

## 📞 Communication Plan

- **Stakeholders:** [Who needs to know]
- **Notification Time:** [When to notify]

## ✅ Approval

- [ ] Technical Lead
- [ ] Manager
- [ ] CAB (if required)
]],
                                generate_uuid(),
                                date, chg_num,
                                title,
                                risk,
                                impact,
                                date,
                                date, chg_num
                            )

                            local dir_path = string.format('%s/%s', vault_path, config.paths.change_requests)
                            if not ensure_directory(dir_path) then return end

                            if write_file(filepath, content) then
                                vim.cmd('edit ' .. filepath)
                                notify(string.format('✅ Created change request: %s', filename))
                            else
                                notify('❌ Failed to create change request', vim.log.levels.ERROR)
                            end
                        end
                    )
                end
            )
        end)
    end)
end

local function capture_oncall()
    local vault_path = config.vault_path
    local week = os.date('Week %W, %Y')
    local date = os.date('%Y-W%W')

    local filename = string.format('ONCALL-%s.md', date)
    local filepath = string.format('%s/%s/%s', vault_path, config.paths.oncall_logs, filename)

    local content = string.format([[---
document_uuid: "%s"
id: "ONCALL-%s"
title: "On-Call Log: %s"
type: "oncall-log"
week: "%s"
total_incidents: 0
total_pages: 0
tags:
  - "oncall"
date_created: "%s"
---

# 📟 On-Call Log: %s

## 📊 Summary

- **Total Pages:** 0
- **Total Incidents:** 0
- **False Alarms:** 0
- **Escalations:** 0

## 🚨 Incidents

### %s

#### Incident 1: [Brief description]
- **Time:** HH:MM
- **Duration:** XX minutes
- **Severity:** P2
- **Resolution:** [What you did]
- **Follow-up:** [Action items]

## 💡 Lessons Learned

[What did you learn this week?]

## 🔧 Improvements Needed

- [ ] Alert tuning needed
- [ ] Runbook creation needed
- [ ] Documentation update

## 📈 Alert Analysis

### False Positives
[List false alarms to tune]

### Alert Volume by Service
[Track which services are noisiest]
]],
        generate_uuid(),
        date,
        week,
        date,
        os.date('%Y-%m-%d'),
        week,
        os.date('%A, %B %d')
    )

    local dir_path = string.format('%s/%s', vault_path, config.paths.oncall_logs)
    if not ensure_directory(dir_path) then return end

    if write_file(filepath, content) then
        vim.cmd('edit ' .. filepath)
        notify(string.format('✅ Created on-call log: %s', filename))
    else
        notify('❌ Failed to create on-call log', vim.log.levels.ERROR)
    end
end

local function capture_til()
    local vault_path = config.vault_path
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'What did you learn?: ' }, function(title)
        if not validate_input(title, 'Title') then return end

        vim.ui.input({ prompt = 'Topic (e.g., JavaScript, DevOps): ' }, function(topic)
            if not validate_input(topic, 'Topic') then return end

            vim.ui.input({ prompt = 'Subject for filename (e.g., Vim-Fundamentals): ' }, function(subject)
                if not validate_input(subject, 'Subject') then return end

                -- Sanitize subject for filename (remove spaces, special chars, convert to kebab-case)
                local safe_subject = sanitize_filename(subject):gsub('-+', '-'):gsub('^-', ''):gsub('-$', '')
                local filename = string.format('TIL-%s-%s.md', date, safe_subject)
                local filepath = string.format('%s/%s/%s', vault_path, config.paths.learning, filename)

                local content = string.format([[---
document_uuid: "%s"
id: "TIL-%s-%s"
title: "%s"
type: "learning-log"
topic: "%s"
confidence: 3
tags:
  - "learning"
  - "til"
date_created: "%s"
---

# 💡 TIL: %s

## 🎯 What I Learned

[Explain the concept]

## 💻 Code Example

```
// Your code example
```

## 🔗 Resources

- [Link to article/docs]

## 🎓 Apply This To

[Where you'll use this knowledge]

## ❓ Questions

[What you still don't understand]
]],
                    generate_uuid(),
                    date, safe_subject,
                    title,
                    topic,
                    date,
                    title
                )

                local dir_path = string.format('%s/%s', vault_path, config.paths.learning)
                if not ensure_directory(dir_path) then return end

                if write_file(filepath, content) then
                    vim.cmd('edit ' .. filepath)
                    notify(string.format('✅ Created learning log: %s', filename))
                else
                    notify('❌ Failed to create learning log', vim.log.levels.ERROR)
                end
            end)
        end)
    end)
end

local function capture_win()
    local vault_path = config.vault_path
    local year = os.date('%Y')
    local date = os.date('%Y-%m-%d')

    vim.ui.input({ prompt = 'Win Number (e.g., 001): ' }, function(win_num)
        if not validate_input(win_num, 'Win Number') then return end

        vim.ui.input({ prompt = 'Achievement Title: ' }, function(title)
            if not validate_input(title, 'Title') then return end

            vim.ui.select(
                { 'high', 'medium', 'low' },
                { prompt = 'Impact Level:' },
                function(impact)
                    if not impact then return end

                    local filename = string.format('WIN-%s-%s.md', year, win_num)
                    local filepath = string.format('%s/%s/%s', vault_path, config.paths.learning, filename)

                    local content = string.format([[---
document_uuid: "%s"
id: "WIN-%s-%s"
title: "%s"
type: "performance-win"
impact: "%s"
category: "achievement"
tags:
  - "achievement"
  - "performance"
date_created: "%s"
---

# 🏆 Win: %s

## 🎯 What I Did

[Describe the achievement]

## 📊 Impact

[Quantify the impact - time saved, cost reduced, etc.]

## 🛠️ How I Did It

[Technical approach and tools used]

## 💡 Skills Demonstrated

- [Skill 1]
- [Skill 2]

## 🎓 What I Learned

[New knowledge or insights gained]
]],
                        generate_uuid(),
                        year, win_num,
                        title,
                        impact,
                        date,
                        title
                    )

                    local dir_path = string.format('%s/%s', vault_path, config.paths.learning)
                    if not ensure_directory(dir_path) then return end

                    if write_file(filepath, content) then
                        vim.cmd('edit ' .. filepath)
                        notify(string.format('✅ Created performance win: %s', filename))
                    else
                        notify('❌ Failed to create performance win', vim.log.levels.ERROR)
                    end
                end
            )
        end)
    end)
end

-- ============================================================================
-- CAPTURE MENU
-- ============================================================================

local function show_capture_menu()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local captures = {
        -- Original captures
        { display = '🚨 Incident (INC)', action = capture_incident },
        { display = '🔍 Root Cause Analysis (RCA)', action = capture_rca },
        { display = '💡 Solution (QSL)', action = capture_solution },
        { display = '💻 Command (CMD)', action = capture_command },
        { display = '✅ Task (TASK)', action = capture_task },
        { display = '💡 Idea (IDEA)', action = capture_idea },
        { display = '🚀 Project (Full Wizard)', action = capture_project },
        -- New captures
        { display = '📖 Runbook (Operations)', action = capture_runbook },
        { display = '🔄 Change Request', action = capture_change_request },
        { display = '📟 On-Call Log', action = capture_oncall },
        { display = '🎓 Today I Learned (TIL)', action = capture_til },
        { display = '🏆 Performance Win', action = capture_win },
    }

    pickers.new({}, {
        prompt_title = 'Obsidian Capture',
        finder = finders.new_table({
            results = captures,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.display,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection and selection.value and selection.value.action then
                    selection.value.action()
                end
            end)
            return true
        end,
    }):find()
end

-- ============================================================================
-- SETUP & KEYMAPS
-- ============================================================================

function M.setup()
    -- Original commands
    vim.api.nvim_create_user_command('ObsidianCapture', show_capture_menu,
        { desc = 'Open Obsidian Capture menu' })
    vim.api.nvim_create_user_command('ObsidianIncident', capture_incident,
        { desc = 'Create new incident' })
    vim.api.nvim_create_user_command('ObsidianRCA', capture_rca,
        { desc = 'Create new RCA' })
    vim.api.nvim_create_user_command('ObsidianSolution', capture_solution,
        { desc = 'Create new solution' })
    vim.api.nvim_create_user_command('ObsidianCommand', capture_command,
        { desc = 'Create new command' })
    vim.api.nvim_create_user_command('ObsidianTask', capture_task,
        { desc = 'Create new task' })
    vim.api.nvim_create_user_command('ObsidianIdea', capture_idea,
        { desc = 'Create new idea' })
    vim.api.nvim_create_user_command('ObsidianProject', capture_project,
        { desc = 'Create new project with wizard' })

    -- New commands
    vim.api.nvim_create_user_command('ObsidianRunbook', capture_runbook,
        { desc = 'Create new runbook' })
    vim.api.nvim_create_user_command('ObsidianChangeRequest', capture_change_request,
        { desc = 'Create new change request' })
    vim.api.nvim_create_user_command('ObsidianOnCall', capture_oncall,
        { desc = 'Create on-call log' })
    vim.api.nvim_create_user_command('ObsidianTIL', capture_til,
        { desc = 'Create Today I Learned entry' })
    vim.api.nvim_create_user_command('ObsidianWin', capture_win,
        { desc = 'Document a performance win' })

    ---    notify('Obsidian Capture System loaded successfully!')
end

function M.keymaps()
    -- Main capture menu
    vim.keymap.set('n', '<leader>oc', show_capture_menu,
        { desc = 'Obsidian Capture Menu' })

    -- Original quick captures
    vim.keymap.set('n', '<leader>oi', capture_incident,
        { desc = 'Capture Incident' })
    vim.keymap.set('n', '<leader>or', capture_rca,
        { desc = 'Capture RCA' })
    vim.keymap.set('n', '<leader>os', capture_solution,
        { desc = 'Capture Solution' })
    vim.keymap.set('n', '<leader>ox', capture_command,
        { desc = 'Capture Command' })
    vim.keymap.set('n', '<leader>ot', capture_task,
        { desc = 'Capture Task' })
    vim.keymap.set('n', '<leader>od', capture_idea,
        { desc = 'Capture Idea' })
    vim.keymap.set('n', '<leader>op', capture_project,
        { desc = 'Capture Project (Wizard)' })

    -- New quick captures
    vim.keymap.set('n', '<leader>oR', capture_runbook,
        { desc = 'Capture Runbook' })
    vim.keymap.set('n', '<leader>oC', capture_change_request,
        { desc = 'Capture Change Request' })
    vim.keymap.set('n', '<leader>oO', capture_oncall,
        { desc = 'Capture On-Call Log' })
    vim.keymap.set('n', '<leader>oL', capture_til,
        { desc = 'Capture TIL' })
    vim.keymap.set('n', '<leader>oW', capture_win,
        { desc = 'Capture Win' })
end

return M
