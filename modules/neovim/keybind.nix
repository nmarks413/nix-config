# this file implements a keybind system, which is a higher level system
# to configure vim.keymaps (note the different name bind vs map)
{
  pkgs,
  lib,
  config,
  ...
}:
let
  keyRemap = mode: key: action: { inherit mode key action; };
  keyCmd =
    mode: key: cmd:
    keyRemap mode key ":${cmd}<Return>";
in
{
  # default binds
  config.vim.keybinds = {
    search-commands = keyCmd "n" "<leader>?" "FzfLua keymaps";

    # user interface
    toggle-explorer = keyCmd "n" "<leader>e" "Neotree toggle";
    reveal-active-file = keyCmd "n" "<leader>E" "Neotree reveal<CR>:Neotree focus";
    lazygit = keyCmd "n" "<leader>gg" "FullscreenTerm ${pkgs.lazygit}/bin/lazygit";

    # pickers
    pick-file = keyCmd "n" "<leader><leader>" "FzfLua files";
    pick-mark = keyCmd "n" "<leader>'" "FzfLua marks";
    #pick-buffer = keyCmd "n" "<leader>b" "FzfLua buffers";
    pick-grep = keyCmd "n" "<leader>ff" "FzfLua grep_project";
    pick-recent-command = keyCmd "n" "<leader>fc" "FzfLua command_history";
    pick-other = keyCmd "n" "<leader>f?" "FzfLua builtin"; # picker of Fzf pickers

    # lsp
    code-action =
      keyCmd "n" "<leader>ca"
        "FzfLua lsp_code_actions winopts.height=15 winopts.backdrop=100 winopts.title=false winopts.preview.title=false winopts.row=1";

    # subtle nice features
    visual-dedent = keyRemap "v" "<" "<gv"; # keep selection
    visual-indent = keyRemap "v" ">" ">gv"; # keep selection
    clear-search-highlights = keyRemap "n" "<esc" ":noh<Return><esc>";
  };

  # implementation
  options.vim.keybinds = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.nullOr (
        lib.types.submodule {
          options = {
            mode = lib.mkOption { type = lib.types.str; };
            key = lib.mkOption { type = lib.types.str; };
            action = lib.mkOption { type = lib.types.str; };
          };
        }
      )
    );
    default = { };
  };
  config.vim.keymaps =
    let
      titleCase =
        str:
        lib.concatStringsSep " " (
          map (
            word:
            lib.strings.toUpper (builtins.substring 0 1 word)
            + builtins.substring 1 (builtins.stringLength word) word
          ) (lib.splitString "-" str)
        );
    in
    builtins.filter (f: f != null) (
      lib.attrsets.mapAttrsToList (
        desc: bind:
        if bind != null then
          {
            desc = titleCase desc;
            inherit (bind) mode key action;
          }
        else
          null
      ) config.vim.keybinds
    );
}
