-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Filetype detection that understands chezmoi names.
--
-- Inside the chezmoi source tree, attribute prefixes (dot_, private_,
-- run_onchange_, ...) and the .tmpl suffix hide the real name from
-- ftdetect, so dot_gitconfig and dot_Brewfile get no filetype. Rebuild
-- the deployed path (dot_ -> ".") and detect on that. Exact-name rules
-- like `Brewfile` still miss the deployed `.Brewfile`, so as a last
-- resort retry without the leading dot. Registered at the lowest
-- priority so builtin and LazyVim rules always win.
local chezmoi_prefixes = {
  "remove_", "create_", "modify_", "run_", "once_", "onchange_", "before_", "after_",
  "symlink_", "exact_", "external_", "encrypted_", "private_", "readonly_",
  "empty_", "executable_",
}

local function chezmoi_deployed_name(name)
  local stripped = true
  while stripped do
    stripped = false
    for _, prefix in ipairs(chezmoi_prefixes) do
      if vim.startswith(name, prefix) then
        name = name:sub(#prefix + 1)
        stripped = true
      end
    end
  end
  if vim.startswith(name, "dot_") then
    name = "." .. name:sub(5)
  end
  return name
end

local function detect_chezmoi_filetype(path)
  if vim.fs.root(path, { ".chezmoiignore", ".chezmoiroot" }) then
    local parts = vim.split(path, "/", { plain = true })
    for i, part in ipairs(parts) do
      parts[i] = chezmoi_deployed_name(part)
    end
    local deployed = table.concat(parts, "/"):gsub("%.tmpl$", "")
    if deployed ~= path then
      local ft = vim.filetype.match({ filename = deployed })
      if ft then
        return ft
      end
    end
  end

  local dir, base = path:match("^(.*/)([^/]+)$")
  if base and vim.startswith(base, ".") then
    return (vim.filetype.match({ filename = dir .. base:sub(2) }))
  end
end

-- The key must not be ".*": snacks.nvim registers that one for bigfile
-- detection, and a later vim.filetype.add on the same key replaces it.
vim.filetype.add({
  pattern = {
    [".*/[^/]*"] = { detect_chezmoi_filetype, { priority = -math.huge } },
  },
})
