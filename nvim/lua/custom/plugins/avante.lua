-- =============================================================================
-- avante.nvim — full config for local Ollama with agentic tool use
-- Place this file at: ~/.config/nvim/lua/plugins/avante.lua
--
-- Prerequisites:
--   1. Neovim >= 0.10.1
--   2. cargo (for building the Rust binary):  curl https://sh.rustup.rs -sSf | sh
--   3. Ollama running locally:                curl https://ollama.ai/install.sh | sh
--   4. Pull a tool-capable model:
--        ollama pull qwen2.5-coder:14b          (recommended — best tool-call support)
--      Other tested options (pick ONE and set `model` below):
--        ollama pull qwen3-coder:8b             (smaller, still good tool use)
--        ollama pull mistral-nemo               (fast, solid tool calling)
--        ollama pull llama3.3:70b               (high quality, needs VRAM)
--
-- ⚠  TOOL USE WARNING: Agentic mode (the mode that lets the AI directly
--    edit your buffers, create files, run shell commands, etc.) requires a
--    model that implements OpenAI-compatible function/tool calling through
--    Ollama's API.  Models that only generate JSON text won't trigger the
--    agent loop.  qwen2.5-coder:14b or qwen3-coder are the safest picks.
--
-- Key bindings (defaults — avante won't override existing maps):
--   <leader>aa   Open / toggle Avante sidebar (AvanteAsk)
--   <leader>ae   Edit selected code with AI (visual mode)
--   <leader>ar   Refresh Avante response
--   <leader>af   Focus Avante sidebar
--   <leader>at   Toggle Avante
--   <leader>ac   Clear chat history
--   <C-s>        Apply the AI's suggested diff (inside Avante buffer)
--   <tab>/<S-tab> Jump between diff hunks
-- =============================================================================

return {
  'yetone/avante.nvim',

  -- Load after the UI has settled — keeps startup fast
  event = 'VeryLazy',

  -- Do NOT pin to a release tag ("*").  The plugin moves fast and tagged
  -- releases often lag behind bug fixes. Pull from main instead.
  version = false,

  -- Build the required Rust binary on install / update
  build = 'make',
  -- Windows alternative (uncomment if needed):
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false",

  -- -----------------------------------------------------------------------
  -- Dependencies
  -- -----------------------------------------------------------------------
  dependencies = {
    -- Core (required)
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',

    -- Image paste support (required when support_paste_from_clipboard = true)
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
          use_absolute_path = true,
        },
      },
    },

    -- Markdown rendering inside the Avante panel
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },

  -- -----------------------------------------------------------------------
  -- Main configuration
  -- -----------------------------------------------------------------------
  opts = {

    -- -------------------------------------------------------------------
    -- Provider: Ollama (first-class, no vendors{} needed)
    -- -------------------------------------------------------------------
    provider = 'ollama',

    providers = {
      ollama = {
        -- Local Ollama endpoint — no trailing /v1
        endpoint = 'http://127.0.0.1:11434',

        model = 'qwen2.5-coder:32b',

        -- Wrapped in a function so it's evaluated after avante loads,
        -- not at file parse time (which causes "module not found" errors).
        is_env_set = function()
          return require('avante.providers.ollama').check_endpoint_alive()
        end,

        -- Generous timeout — 32b is slow on first token
        timeout = 180000,

        -- IMPORTANT: qwen2.5-coder:32b supports native tool calling but
        -- still benefits from the ReAct prompt to avoid the "spinning"
        -- loop where it narrates tool calls as text instead of emitting
        -- them as structured API calls.
        use_ReAct_prompt = true,

        extra_request_body = {
          options = {
            -- qwen2.5-coder:32b supports up to 32k context natively.
            -- Set this explicitly — Ollama defaults to 2048 which is far
            -- too small and is the primary cause of str_replace picking up
            -- lines from the wrong function (the model sees a truncated
            -- file and generates old_str that doesn't uniquely match).
            num_ctx = 32768,

            -- Must be 0 for reliable tool calling. Any value above 0
            -- causes the model to deviate from the tool call schema and
            -- produces the spinning / narration loop.
            temperature = 0,

            -- Penalise repeating the same token — reduces the looping
            -- behaviour where the model re-emits the same tool call text.
            repeat_penalty = 1.1,

            keep_alive = '15m',
          },
        },
      },
    },

    -- -------------------------------------------------------------------
    -- Mode: "agentic" is required for autonomous buffer edits via tools.
    --
    -- In agentic mode the AI runs a loop: it calls tools (view_file,
    -- str_replace, write_to_file, bash …) autonomously until it signals
    -- completion. This is what makes changes appear directly in your buffer
    -- without you needing to manually apply a diff.
    --
    -- "legacy" mode only generates a diff panel for you to approve line by
    -- line — it does NOT call tools automatically.
    -- -------------------------------------------------------------------
    mode = 'agentic',

    -- -------------------------------------------------------------------
    -- Behaviour
    -- -------------------------------------------------------------------
    behaviour = {
      -- Automatically focus the sidebar when it opens
      auto_focus_sidebar = true,

      -- Auto-suggestions (inline ghost text) — expensive with local models,
      -- disabled by default.  Enable if you have a fast GPU.
      auto_suggestions = false,

      -- When true, diffs are applied to the buffer automatically after the
      -- AI finishes in legacy mode. Irrelevant in agentic mode but harmless.
      auto_apply_diff_after_generation = false,

      -- After a response finishes, jump the cursor into the result buffer
      jump_result_buffer_on_finish = false,

      -- Allow pasting images from clipboard into the chat (requires img-clip)
      support_paste_from_clipboard = true,

      -- IMPORTANT: keep this false for local models. When true, avante
      -- strips unchanged lines before sending context to the model, which
      -- causes str_replace to generate old_str that bleeds across function
      -- boundaries (the model loses positional accuracy in the truncated view).
      minimize_diff = false,

      -- Show token count in the UI
      enable_token_counting = false, -- can be slow with local models

      -- Automatically add the file you're editing to the chat context
      auto_add_current_file = true,

      -- ----------------------------------------------------------------
      -- Tool permissions — IMPORTANT for agentic buffer edits
      --
      -- true  = approve every tool call without prompting (fastest, least
      --         friction; the AI edits buffers/files without confirmation)
      -- false = prompt for every tool call (safest)
      -- list  = approve only the listed tools silently, prompt for others
      --         e.g. { "str_replace", "view_file", "write_to_file" }
      -- ----------------------------------------------------------------
      auto_approve_tool_permissions = false,

      -- Inline buttons look cleaner than a popup for confirmations
      confirmation_ui_style = 'inline_buttons',
    },

    -- -------------------------------------------------------------------
    -- Window layout
    -- -------------------------------------------------------------------
    windows = {
      -- Sidebar opens on the right
      position = 'right',

      -- Width as % of the total window
      width = 35,

      sidebar_header = {
        enabled = true,
        align = 'center',
        rounded = true,
      },

      input = {
        prefix = '> ',
        height = 8,
      },

      edit = {
        border = 'rounded',
        start_insert = true,
      },

      ask = {
        floating = false, -- Use the sidebar panel (not a floating window)
        start_insert = true,
        border = 'rounded',
        focus_on_apply = 'ours', -- After applying diff, focus our side
      },
    },

    -- -------------------------------------------------------------------
    -- File / buffer selector
    --
    -- When you use @file mentions in the chat avante opens a picker.
    -- Change "native" to "telescope", "fzf_lua", "mini_pick", or "snacks"
    -- if you have one of those installed.
    -- -------------------------------------------------------------------
    selector = {
      provider = 'native',
    },

    file_selector = {
      provider = 'native',
    },

    -- -------------------------------------------------------------------
    -- Repo map — helps the AI understand project structure
    -- -------------------------------------------------------------------
    repo_map = {
      ignore_patterns = {
        '%.git',
        '%.worktree',
        '__pycache__',
        'node_modules',
        '%.lock',
        'dist',
        'build',
        '%.min%.js',
      },
    },

    -- -------------------------------------------------------------------
    -- Hints in the UI (keyboard shortcut reminders)
    -- -------------------------------------------------------------------
    hints = { enabled = true },

    -- -------------------------------------------------------------------
    -- RAG service — disabled (requires Docker; enable separately if wanted)
    -- -------------------------------------------------------------------
    rag_service = {
      enabled = false,
    },
  }, -- end opts
}
