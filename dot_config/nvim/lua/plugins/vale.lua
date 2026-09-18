-- Vale prose linting: markdown gets full style rules, code filetypes
-- get comment linting (vale extracts comments per dot_vale.ini's
-- code section). Requires `vale` on PATH (Brewfile).
return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    local fts = {
      "markdown",
      "c",
      "cpp",
      "css",
      "elixir",
      "go",
      "java",
      "javascript",
      "javascriptreact",
      "kotlin",
      "lua",
      "php",
      "python",
      "ruby",
      "rust",
      "scala",
      "sh",
      "swift",
      "typescript",
      "typescriptreact",
    }
    for _, ft in ipairs(fts) do
      opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
      table.insert(opts.linters_by_ft[ft], "vale")
    end
  end,
}
