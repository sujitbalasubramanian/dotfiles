local term_state = {}

local function create_floating_term_win(opts)
  opts = opts or {}

  local width = math.floor(vim.o.columns)
  local height = math.floor(vim.o.lines)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
  }

  local buf = (opts.buf and vim.api.nvim_buf_is_valid(opts.buf)) and opts.buf or vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  return { buf = buf, win = win }
end

local function is_valid_term_buf(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
  return buftype == "terminal"
end

local function open_named_terminal(name, cmd)
  local state = term_state[name]

  if state == nil or not is_valid_term_buf(state.buf) then
    term_state[name] = create_floating_term_win()
    vim.api.nvim_set_current_buf(term_state[name].buf)
    vim.fn.termopen(cmd or vim.o.shell)
  elseif not vim.api.nvim_win_is_valid(state.win) then
    term_state[name] = create_floating_term_win { buf = state.buf }
    vim.api.nvim_set_current_win(term_state[name].win)
    vim.api.nvim_set_current_buf(term_state[name].buf)
  else
    vim.api.nvim_win_hide(state.win)
    return
  end
end

-- Parse args like: name=myterm cmd=lazygit
local function parse_args(str)
  local out = {}
  for k, v in string.gmatch(str, "(%w+)=([^\n%s]+)") do
    out[k] = v
  end
  return out
end

-- :Term name=myterm [cmd=mycmd]
vim.api.nvim_create_user_command("Term", function(args)
  local opts = parse_args(args.args)

  if not opts.name then
    print "Usage: :Term name=myterm [cmd=lazygit]"
    return
  end

  open_named_terminal(opts.name, opts.cmd)
end, {
  nargs = "+", -- one or more args
  complete = function()
    return vim.tbl_keys(term_state)
  end,
})

-- Normal mode keymaps
local km = vim.keymap.set

km("t", "<esc><esc>", "<c-\\><c-n>")

km("n", "t1", ":Term name=scratch<CR>", { desc = "Open Scratch Terminal", noremap = true, silent = true })
km("n", "t2", ":Term name=runner<CR>", { desc = "Open Runner Terminal", noremap = true, silent = true })
km("n", "tf", ":Term name=lazygit cmd=yazi<CR>", { desc = "Open File Manager", noremap = true, silent = true })
km("n", "tg", ":Term name=lazygit cmd=lazygit<CR>", { desc = "Open LazyGit", noremap = true, silent = true })
km("n", "td", ":Term name=lazydocker cmd=lazydocker<CR>", { desc = "Open LazyDocker", noremap = true, silent = true })

-- Picker to search & toggle terminals
local function open_term_picker()
  local items = vim.tbl_keys(term_state)
  if #items == 0 then
    print "No terminals available."
    return
  end

  require("mini.pick").start {
    source = {
      name = "Terminals",
      items = items,
      choose = function(term_name)
        vim.schedule(function()
          open_named_terminal(term_name)
        end)
      end,
    },
    prompt = "Select terminal > ",
  }
end

vim.keymap.set("n", "ts", open_term_picker, { desc = "Search and open terminal", noremap = true, silent = true })
