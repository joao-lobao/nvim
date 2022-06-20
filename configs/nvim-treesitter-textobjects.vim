lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>z"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>Z"] = "@parameter.inner",
      },
    },
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- Or you can define your own textobjects like this
        --["iF"] = {
        --  python = "(function_definition) @function",
        --  cpp = "(function_definition) @function",
        --  c = "(function_definition) @function",
        --  java = "(method_declaration) @function",
      },
    },
  },
}
EOF

