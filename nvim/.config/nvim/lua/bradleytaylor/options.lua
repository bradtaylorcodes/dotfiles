local opt = vim.opt

-- keep fat cursor
opt.guicursor = ''

-- line numbers
opt.relativenumber = true
opt.number = true

-- enable mouse
opt.mouse = 'a'

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.softtabstop = 2
opt.smartindent = false

-- line wrapping
opt.wrap = false

-- never less than 10 lines when scrolling
opt.scrolloff = 10

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- preview substitutions live as you type
opt.inccommand = 'split'

-- cursor line
opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes'

-- backspace
opt.backspace = 'indent,eol,start'

-- split windows
opt.splitright = true
opt.splitbelow = true

-- don't show mode since it's in status line
opt.showmode = false

-- decrease update time
opt.updatetime = 250

opt.cmdheight = 1
