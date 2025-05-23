return {
  {
    'echasnovski/mini.move',
    version = false,
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Move in Visual mode
        left = '<',
        right = '>',
        down = 'J',
        up = 'K',

        -- Move current line in Normal mode
        line_left = '<',
        line_right = '>',
      },

      -- Options which control moving behavior
      options = {
        -- Automatically reindent selection during linewise vertical move
        reindent_linewise = true,
      },
    },
  },
}
