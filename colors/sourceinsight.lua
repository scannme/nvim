-- Source Insight (light green) — matches the MyTerm terminal theme.

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.o.background = "light"
vim.g.colors_name = "sourceinsight"

local p = {
  bg          = "#d4e8d4",
  bg_alt      = "#c5dec5",
  bg_dim      = "#b8d4b8",
  bg_sel      = "#a8d0a8",
  bg_cursor   = "#c0dcc0",
  bg_float    = "#aac8aa",
  border_str  = "#6a8a6a",
  fg          = "#1a2e1a",
  fg_dim      = "#3a4a3a",
  fg_muted    = "#5a6a5a",
  border      = "#8aaa8a",
  red         = "#a80000",
  red_b       = "#c40000",
  green       = "#005000",
  green_b     = "#007020",
  yellow      = "#7a5500",
  yellow_b    = "#946600",
  blue        = "#0033a0",
  blue_b      = "#003fc4",
  magenta     = "#7a0070",
  magenta_b   = "#940088",
  cyan        = "#006a73",
  cyan_b      = "#007e8a",
}

local function hi(group, opts) vim.api.nvim_set_hl(0, group, opts) end

-- UI
hi("Normal",        { fg = p.fg,       bg = p.bg })
hi("NormalNC",      { fg = p.fg,       bg = p.bg })
hi("NormalFloat",   { fg = p.fg,        bg = p.bg_float })
hi("FloatBorder",   { fg = p.border_str, bg = p.bg_float })
hi("FloatTitle",    { fg = p.blue,      bg = p.bg_float, bold = true })
hi("Cursor",        { reverse = true })
hi("lCursor",       { reverse = true })
hi("TermCursor",    { reverse = true })
hi("CursorLine",    { bg = p.bg_cursor })
hi("CursorColumn",  { bg = p.bg_cursor })
hi("ColorColumn",   { bg = p.bg_alt })
hi("LineNr",        { fg = p.fg_muted, bg = p.bg_alt })
hi("CursorLineNr",  { fg = p.blue,     bg = p.bg_alt, bold = true })
hi("SignColumn",    { fg = p.fg_muted, bg = p.bg })
hi("VertSplit",     { fg = p.border,   bg = p.bg })
hi("WinSeparator",  { fg = p.border,   bg = p.bg })
hi("StatusLine",    { fg = p.fg,       bg = p.border, bold = true })
hi("StatusLineNC",  { fg = p.fg_muted, bg = p.bg_dim })
hi("TabLine",       { fg = p.fg_muted, bg = p.bg_dim })
hi("TabLineSel",    { fg = p.fg,       bg = p.bg, bold = true })
hi("TabLineFill",   { bg = p.bg_dim })
hi("Visual",        { bg = p.bg_sel })
hi("Search",        { fg = p.fg,       bg = "#f0e090" })
hi("IncSearch",     { fg = p.bg,       bg = p.yellow_b, bold = true })
hi("CurSearch",     { fg = p.bg,       bg = p.yellow_b, bold = true })
hi("MatchParen",    { bg = p.bg_sel,   bold = true })
hi("Pmenu",         { fg = p.fg,       bg = p.bg_alt })
hi("PmenuSel",      { fg = p.bg,       bg = p.blue,     bold = true })
hi("PmenuSbar",     { bg = p.bg_dim })
hi("PmenuThumb",    { bg = p.border })
hi("Folded",        { fg = p.fg_muted, bg = p.bg_alt, italic = true })
hi("FoldColumn",    { fg = p.fg_muted, bg = p.bg })
hi("WinBar",        { fg = p.fg,       bg = p.bg_alt, bold = true })
hi("WinBarNC",      { fg = p.fg_muted, bg = p.bg_alt })
hi("Title",         { fg = p.blue,     bold = true })
hi("Directory",     { fg = p.blue,     bold = true })
hi("Question",      { fg = p.green_b })
hi("MoreMsg",       { fg = p.green_b })
hi("WarningMsg",    { fg = p.yellow_b, bold = true })
hi("ErrorMsg",      { fg = p.red_b,    bold = true })
hi("NonText",       { fg = p.border })
hi("SpecialKey",    { fg = p.border })
hi("Whitespace",    { fg = p.border })

-- Classic syntax
hi("Comment",       { fg = p.green_b,  italic = true })
hi("Constant",      { fg = p.red })
hi("String",        { fg = p.magenta })
hi("Character",     { fg = p.magenta })
hi("Number",        { fg = p.red })
hi("Boolean",       { fg = p.red,      bold = true })
hi("Float",         { fg = p.red })
hi("Identifier",    { fg = p.fg })
hi("Function",      { fg = p.blue,     bold = true })
hi("Statement",     { fg = p.blue,     bold = true })
hi("Conditional",   { fg = p.blue,     bold = true })
hi("Repeat",        { fg = p.blue,     bold = true })
hi("Label",         { fg = p.blue,     bold = true })
hi("Operator",      { fg = p.fg })
hi("Keyword",       { fg = p.blue,     bold = true })
hi("Exception",     { fg = p.red_b,    bold = true })
hi("PreProc",       { fg = p.yellow })
hi("Include",       { fg = p.yellow })
hi("Define",        { fg = p.yellow })
hi("Macro",         { fg = p.yellow })
hi("Type",          { fg = p.cyan })
hi("StorageClass",  { fg = p.blue,    bold = true })
hi("Structure",     { fg = p.cyan_b,  bold = true })
hi("Typedef",       { fg = p.cyan_b })
hi("Special",       { fg = p.cyan })
hi("SpecialChar",   { fg = p.cyan })
hi("Tag",           { fg = p.cyan })
hi("Delimiter",     { fg = p.fg_dim })
hi("SpecialComment",{ fg = p.cyan,     italic = true })
hi("Todo",          { fg = p.red_b,    bg = "#f0e090", bold = true })
hi("Underlined",    { fg = p.blue,     underline = true })
hi("Error",         { fg = p.red_b,    bold = true })

-- Diff
hi("DiffAdd",       { bg = "#cdebcd" })
hi("DiffChange",    { bg = "#e0e0c0" })
hi("DiffDelete",    { fg = p.red,     bg = "#e8c8c8" })
hi("DiffText",      { bg = "#f0e090", bold = true })

-- Diagnostics (LSP)
hi("DiagnosticError",      { fg = p.red_b })
hi("DiagnosticWarn",       { fg = p.yellow_b })
hi("DiagnosticInfo",       { fg = p.blue })
hi("DiagnosticHint",       { fg = p.cyan })
hi("DiagnosticOk",         { fg = p.green_b })
hi("DiagnosticUnderlineError", { sp = p.red_b,    undercurl = true })
hi("DiagnosticUnderlineWarn",  { sp = p.yellow_b, undercurl = true })
hi("DiagnosticUnderlineInfo",  { sp = p.blue,     undercurl = true })
hi("DiagnosticUnderlineHint",  { sp = p.cyan,     undercurl = true })

-- LSP
hi("LspReferenceText",     { bg = p.bg_sel })
hi("LspReferenceRead",     { bg = p.bg_sel })
hi("LspReferenceWrite",    { bg = p.bg_sel, bold = true })
hi("LspSignatureActiveParameter", { fg = p.fg, bg = "#f0e090", bold = true })

-- GitSigns
hi("GitSignsAdd",          { fg = p.green_b })
hi("GitSignsChange",       { fg = p.yellow_b })
hi("GitSignsDelete",       { fg = p.red_b })
hi("GitSignsCurrentLineBlame", { fg = p.border, italic = true })

-- gitcommit (used by blame popup and commit message editing)
hi("gitcommitHash",        { fg = p.yellow_b, bold = true })
hi("gitcommitAuthor",      { fg = p.cyan_b })
hi("gitcommitDate",        { fg = p.fg_muted, italic = true })
hi("gitcommitSummary",     { fg = p.fg,       bold = true })
hi("gitcommitOverflow",    { fg = p.red_b })
hi("gitcommitBlank",       { fg = p.fg_muted })
hi("gitcommitBranch",      { fg = p.magenta,  bold = true })
hi("gitcommitHeader",      { fg = p.blue,     bold = true })
hi("gitcommitSelectedType",   { fg = p.green_b })
hi("gitcommitSelectedFile",   { fg = p.cyan })
hi("gitcommitUntrackedFile",  { fg = p.red })
hi("gitcommitDiscardedType",  { fg = p.fg_muted })
hi("gitcommitDiscardedFile",  { fg = p.fg_muted, italic = true })

-- Treesitter (newer @-style groups)
hi("@variable",            { fg = p.fg })
hi("@variable.builtin",    { fg = p.red,      italic = true })
hi("@variable.parameter",  { fg = p.fg_dim,   italic = true })
hi("@variable.member",     { fg = p.yellow_b })
hi("@constant",            { fg = p.red })
hi("@constant.builtin",    { fg = p.red,      bold = true })
hi("@module",              { fg = p.cyan_b })
hi("@string",              { fg = p.magenta })
hi("@string.escape",       { fg = p.cyan })
hi("@string.special",      { fg = p.cyan_b })
hi("@character",           { fg = p.magenta })
hi("@number",              { fg = p.red })
hi("@boolean",             { fg = p.red,      bold = true })
hi("@function",            { fg = p.blue,     bold = true })
hi("@function.builtin",    { fg = p.blue,     italic = true })
hi("@function.call",       { fg = p.blue })
hi("@function.macro",      { fg = p.yellow })
hi("@method",              { fg = p.cyan_b,   bold = true })
hi("@method.call",         { fg = p.cyan_b })
hi("@constructor",         { fg = p.cyan_b,   bold = true })
hi("@keyword",             { fg = p.blue,     bold = true })
hi("@keyword.return",      { fg = p.red_b,    bold = true })
hi("@keyword.operator",    { fg = p.blue,     bold = true })
hi("@keyword.import",      { fg = p.yellow,   bold = true })
hi("@conditional",         { fg = p.blue,     bold = true })
hi("@repeat",              { fg = p.blue,     bold = true })
hi("@operator",            { fg = p.fg })
hi("@type",                { fg = p.cyan })
hi("@type.builtin",        { fg = p.cyan,     italic = true })
hi("@type.definition",     { fg = p.cyan_b,   bold = true })
hi("@type.qualifier",      { fg = p.blue,     bold = true })
hi("@attribute",           { fg = p.yellow,   italic = true })
hi("@property",            { fg = p.yellow_b })
hi("@field",               { fg = p.yellow_b })
hi("@parameter",           { fg = p.fg_dim,   italic = true })
hi("@namespace",           { fg = p.cyan_b })
hi("@comment",             { fg = p.green_b,  italic = true })
hi("@punctuation",         { fg = p.fg_muted })
hi("@punctuation.bracket", { fg = p.fg_muted })
hi("@punctuation.delimiter", { fg = p.fg_muted })
hi("@tag",                 { fg = p.cyan })
hi("@tag.attribute",       { fg = p.yellow })
hi("@tag.delimiter",       { fg = p.fg_muted })

-- LSP semantic tokens (overrides treesitter — gopls / clangd / etc.)
hi("@lsp.type.namespace",         { link = "@namespace" })
hi("@lsp.type.type",              { link = "@type" })
hi("@lsp.type.class",             { link = "@type.definition" })
hi("@lsp.type.interface",         { link = "@type.definition" })
hi("@lsp.type.struct",            { link = "@type.definition" })
hi("@lsp.type.enum",              { link = "@type" })
hi("@lsp.type.enumMember",        { link = "@constant" })
hi("@lsp.type.typeParameter",     { fg = p.cyan,    italic = true })
hi("@lsp.type.function",          { link = "@function.call" })
hi("@lsp.type.method",            { link = "@method.call" })
hi("@lsp.type.macro",             { link = "@function.macro" })
hi("@lsp.type.variable",          { link = "@variable" })
hi("@lsp.type.parameter",         { fg = p.fg_dim,  italic = true })
hi("@lsp.type.property",          { fg = p.yellow_b })
hi("@lsp.type.keyword",           { link = "@keyword" })
hi("@lsp.type.modifier",          { link = "@keyword" })
hi("@lsp.type.comment",           { link = "@comment" })
hi("@lsp.type.string",            { link = "@string" })
hi("@lsp.type.number",            { link = "@number" })
hi("@lsp.type.operator",          { link = "@operator" })
hi("@lsp.type.decorator",         { link = "@attribute" })
hi("@lsp.type.event",             { link = "@constant" })
hi("@lsp.type.regexp",            { fg = p.cyan_b })
hi("@lsp.type.label",             { link = "Label" })
hi("@lsp.type.builtinConstant",   { link = "@constant.builtin" })

-- Modifier-aware combinations (Go stdlib types/funcs, readonly vars, etc.)
hi("@lsp.typemod.function.defaultLibrary",   { fg = p.blue,    italic = true })
hi("@lsp.typemod.method.defaultLibrary",     { fg = p.cyan_b,  italic = true })
hi("@lsp.typemod.type.defaultLibrary",       { fg = p.cyan,    italic = true })
hi("@lsp.typemod.variable.defaultLibrary",   { fg = p.red,     italic = true })
hi("@lsp.typemod.variable.readonly",         { link = "@constant" })
hi("@lsp.typemod.variable.global",           { fg = p.fg,      bold = true })
hi("@lsp.typemod.variable.definition",       { fg = p.fg,      bold = true })
hi("@lsp.typemod.function.definition",       { fg = p.blue,    bold = true })
hi("@lsp.typemod.method.definition",         { fg = p.cyan_b,  bold = true })
hi("@lsp.typemod.parameter.declaration",     { fg = p.fg_dim,  italic = true })
hi("@lsp.typemod.property.declaration",      { fg = p.yellow_b, bold = true })
hi("@lsp.typemod.type.definition",           { fg = p.cyan_b,  bold = true })
hi("@lsp.mod.deprecated",                    { strikethrough = true, fg = p.fg_muted })

-- Telescope
hi("TelescopeBorder",      { fg = p.border,  bg = p.bg_alt })
hi("TelescopeNormal",      { fg = p.fg,      bg = p.bg_alt })
hi("TelescopeSelection",   { fg = p.bg,      bg = p.blue, bold = true })
hi("TelescopeMatching",    { fg = p.red_b,   bold = true })
hi("TelescopePromptPrefix",{ fg = p.blue })

-- NvimTree
hi("NvimTreeNormal",       { fg = p.fg,      bg = p.bg_alt })
hi("NvimTreeFolderIcon",   { fg = p.yellow_b })
hi("NvimTreeFolderName",   { fg = p.blue,    bold = true })
hi("NvimTreeOpenedFolderName", { fg = p.blue,    bold = true, italic = true })
hi("NvimTreeRootFolder",   { fg = p.magenta, bold = true })
hi("NvimTreeGitDirty",     { fg = p.yellow_b })
hi("NvimTreeGitNew",       { fg = p.green_b })
hi("NvimTreeGitDeleted",   { fg = p.red_b })

-- WhichKey
hi("WhichKey",             { fg = p.blue,    bold = true })
hi("WhichKeyGroup",        { fg = p.magenta })
hi("WhichKeyDesc",         { fg = p.fg })
hi("WhichKeySeparator",    { fg = p.fg_muted })
hi("WhichKeyFloat",        { bg = p.bg_alt })
