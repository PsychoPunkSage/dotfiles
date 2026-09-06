-- Workaround: tmux mangles newlines inside bracketed paste when extended keys
-- are enabled.
--
-- With `set -s extended-keys on|always` in tmux.conf, tmux runs the *body* of a
-- bracketed paste through its key encoder. The LF between pasted lines is
-- Ctrl-J, so it arrives here as a literal escape sequence instead of a newline:
--
--   extended-keys-format xterm (default) ->  ESC [ 27;5;106 ~
--   extended-keys-format csi-u           ->  ESC [ 106;5 u
--
-- Because it is inside a paste, Neovim inserts it verbatim as text, which is
-- what makes multi-line pastes come out as one long line full of `[27;5;106~`.
--
-- Upstream: tmux/tmux#4592, tmux/tmux#4163, neovim/neovim#38021 (blocked on
-- tmux). Turning extended keys off in tmux also fixes it, but that costs
-- Shift+Enter/Ctrl+Enter detection in TUIs like Claude Code -- which is exactly
-- why tmux.conf enables them. So undo the damage here instead.
--
-- Delete this file once tmux ships a fix.

-- Ctrl-J (106) and Ctrl-Enter (13), in both encodings tmux can emit.
local ENCODED_NEWLINES = {
  '\27%[27;5;106~',
  '\27%[106;5u',
  '\27%[27;5;13~',
  '\27%[13;5u',
}

local orig_paste = vim.paste

-- A mangled paste has no real newlines, so the whole thing is one long line and
-- Neovim streams it to vim.paste() in chunks (phase 1 -> 2... -> 3). A chunk
-- boundary can land in the middle of an escape sequence, so hold back any
-- unterminated trailing sequence and glue it onto the next chunk.
local carry = ''

-- ESC, ESC[, or ESC[ followed by digits/semicolons but no `~`/`u` terminator.
local PARTIAL_TAIL = '\27%[?[%d;]*$'

vim.paste = function(lines, phase)
  -- phase 1 starts a streamed paste, -1 is a complete one-shot paste.
  if phase == 1 or phase == -1 then
    carry = ''
  end

  lines = vim.deepcopy(lines)
  if carry ~= '' then
    lines[1] = carry .. (lines[1] or '')
    carry = ''
  end

  -- More chunks are coming, so a partial sequence at the very end is not
  -- garbage yet -- stash it. On the final chunk there is nothing left to wait
  -- for, so let it through as literal text.
  local more_coming = phase == 1 or phase == 2
  if more_coming and #lines > 0 then
    local last = lines[#lines]
    local at = last:find(PARTIAL_TAIL)
    if at then
      carry = last:sub(at)
      lines[#lines] = last:sub(1, at - 1)
    end
  end

  local out = {}
  for _, line in ipairs(lines) do
    for _, pat in ipairs(ENCODED_NEWLINES) do
      line = line:gsub(pat, '\n')
    end
    if line:find('\n', 1, true) then
      vim.list_extend(out, vim.split(line, '\n', { plain = true }))
    else
      out[#out + 1] = line
    end
  end

  return orig_paste(out, phase)
end
