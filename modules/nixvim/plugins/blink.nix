{
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      gh
      wordnet
      glab
    ];

    extraPlugins = [
    ];

    plugins = {
      blink-cmp = {
        enable = true;

        lazyLoad.settings.event = [
          "InsertEnter"
          "CmdlineEnter"
        ];

        settings = {
          keymap.preset = "super-tab";
          completion = {
            accept.auto_brackets.enabled = false;
            ghost_test.enabled = false;

            list.selection = {
              preselect = true;
              auto_insert = false;
            };

            documentation = {
              auto_show = true;

              window.border = "rounded";
            };
          };

          menu.draw.components = {
            kind_icon.text.__raw = ''
              function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                -- Check for both nil and the default fallback icon
                if not kind_icon or kind_icon == '󰞋' then
                  -- Use our configured kind_icons
                  return require('blink.cmp.config').appearance.kind_icons[ctx.kind] or ""
                end
                return kind_icon
              end,
              -- Optionally, you may also use the highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end
            '';
          };
        };

        fuzzy = {
          implementation = "prefer_rust_with_warning";
        };
      };
    };
  };
}
