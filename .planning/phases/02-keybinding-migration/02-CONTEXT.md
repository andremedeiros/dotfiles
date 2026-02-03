# Phase 2: Keybinding Migration - Context

**Gathered:** 2026-02-03
**Status:** Ready for planning

<domain>
## Phase Boundary

Migrate custom keybindings from old vimscript config to LazyVim while preserving muscle memory. Specific bindings to implement: H/L for line start/end, // to clear search highlighting, visual mode < and > indent without losing selection, Leader+p for file finder, Leader+Tab for alternate buffer, Leader+z to toggle window zoom. Integrate all custom bindings with which-key for discoverability.

</domain>

<decisions>
## Implementation Decisions

### Conflict Resolution
- Custom bindings take absolute priority over LazyVim defaults
- Listed bindings (H/L, //, visual indent, Leader+p, Leader+Tab, Leader+z) are non-negotiable — override without checking
- If LazyVim has a useful feature that would be overridden, Claude has discretion to move it elsewhere or drop it based on value
- No documentation of what was overridden or moved — trust the decisions made
- No visual feedback when bindings override LazyVim features — silent operation
- Config should be organized clearly by category with comments for easy future modification
- For navigation bindings (H/L), add compatibility code if LazyVim plugins require default behavior
- Future plugin conflicts: Claude has discretion to determine priority based on plugin importance

### Leader Key Strategy
- Use Space as leader key (LazyVim default)
- Leader+p and Leader+Tab override LazyVim defaults with specified behavior
- No local leader key — keep it simple with Space as the only leader

### Plugin Integration
- Map old bindings to LazyVim plugin equivalents (Telescope, neo-tree, etc.)
- Use plugin-specific APIs for better integration and features
- Leader+p uses LazyVim's project-aware command (not basic Telescope find_files)
- Leader+z uses existing LazyVim plugin for window zoom

### Which-key Organization
- Integrate custom bindings into LazyVim's existing categories (find, git, search, etc.)
- Use descriptive action labels: "Find files" for Leader+p, "Toggle zoom" for Leader+z
- Include all custom bindings in which-key (leader and non-leader) for complete discoverability
- Show only what bindings do now — no historical override information

### Claude's Discretion
- Determining when to move vs drop overridden LazyVim features based on value
- Resolving future plugin conflicts based on plugin importance
- Choosing when to use plugin-specific vs generic commands
- Specific Telescope integration details
- Assessing which LazyVim zoom plugin to use
- Determining appropriate organization level for config structure
- Writing appropriate which-key labels based on binding purpose

</decisions>

<specifics>
## Specific Ideas

- Required bindings from old config:
  - H/L → move to line start/end
  - // → clear search highlighting
  - < and > in visual mode → indent without losing selection
  - Leader+p → file finder (Telescope project-aware)
  - Leader+Tab → alternate buffer
  - Leader+z → toggle window zoom

- LazyVim's Space leader should be adopted for consistency
- Config should be clearly organized with comments for maintainability
- All custom bindings should integrate with which-key for discoverability

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 02-keybinding-migration*
*Context gathered: 2026-02-03*
