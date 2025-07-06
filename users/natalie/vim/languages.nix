{
  flake,
  user,
  host,
  pkgs,
  ...
}:
{
  vim = {
    extraPackages = with pkgs; [
      python312Packages.pylatexenc
      nixd
    ];
    lsp = {
      servers = {
        nil = {
          settings.nil.nix.flake = {

            autoArchive = true;
            autoEvalInputs = true;

          };
        };
        nixd = {
          settings.nixd = {
            nixpkgs.expr = ''import "${flake.inputs.nixpkgs}" { }'';

            options =
              {
                home-manager = {
                  expr = ''(let pkgs = import "${flake.inputs.nixpkgs}" { }; lib = import "${flake.inputs.home-manager}/modules/lib/stdlib-extended.nix" pkgs.lib; in (lib.evalModules { modules =  (import "${flake.inputs.home-manager}/modules/modules.nix") { inherit lib pkgs;check = false;}; })).options'';
                  # (builtins.getFlake "${flakePath}").${darwin}Configurations.${hostname}.options.home-manager.users.type.getSubOptions [ ]'';
                };
              }
              // pkgs.lib.optionalAttrs host.darwin {
                nix-darwin = {
                  expr = ''(let pkgs = import "${flake.inputs.nixpkgs}" { }; in (pkgs.lib.evalModules { modules =  (import "${flake.inputs.darwin}/modules/module-list.nix"); check = false;})).options'';
                  # (builtins.getFlake "${flakePath}").darwinConfigurations.${hostname}.options'';
                };
              }
              // pkgs.lib.optionalAttrs host.linux {
                nixos = {
                  expr = ''(let pkgs = import "${flake.inputs.nixpkgs}" { }; in (pkgs.lib.evalModules { modules =  (import "${flake.inputs.nixpkgs}/nixos/modules/module-list.nix"); check = false;})).options'';
                  # (builtins.getFlake "${flakePath}").nixosConfigurations.${hostname}.options'';
                };
              };
          };
        };
      };
    };
    languages = {
      python.format.type = "ruff";
      markdown = {
        enable = true;
        extensions.render-markdown-nvim = {
          enable = true;
        };
      };
      nix.format.enable = true;
    };

    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          fish = [ "fish_indent" ];
          tex = [ "latexindent" ];
        };
      };
    };
    diagnostics = {
      enable = true;
      config = {
        virtual_text = {
          format = pkgs.lib.generators.mkLuaInline ''
            function(diagnostic)
              return string.format("%s (%s)", diagnostic.message, diagnostic.source)
            end
          '';
        };
      };
      nvim-lint = {
        enable = true;
        linters_by_ft = {
          nix = [ "statix" ];
          tex = [ "chktex" ];
          haskell = [ "hlint" ];
        };

        linters = {
          chktex = {
            ignore_exitcode = true;
          };
        };
      };
    };
    treesitter = {
      enable = true;
      fold = true;
      addDefaultGrammars = true;
      highlight = {
        additionalVimRegexHighlighting = true;
      };

      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        markdown_inline
        markdown
      ];

      highlight.enable = true;
      indent.enable = false;
    };

    visuals = {
      fidget-nvim = {
        setupOpts = {
          logger.level = "trace";
        };
      };
    };

    ui = {
      nvim-ufo = {
        enable = true;
      };
    };
    autocomplete.blink-cmp = {
      enable = true;
      mappings = {
        close = null;
        complete = null;
        confirm = null;
        next = null;
        previous = null;
        scrollDocsDown = null;
        scrollDocsUp = null;
      };

      setupOpts = {
        keymap = {
          preset = "super-tab";
        };
        completion = {
          ghost_text.enabled = false;
          list.selection.preselect = true;
          trigger = {
            show_in_snippet = true;
          };
          accept.auto_brackets.enabled = true;
        };
        signature = {
          enabled = true;
        };
      };
    };

    lazy.plugins."blink.pairs" = {
      enabled = true;
      package = pkgs.vimPlugins.blink-pairs;
      setupModule = "blink.pairs";
      setupOpts = {
        mappings = {
          # -- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
          enabled = true;
          # -- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L10
          pairs = [ ];
        };
        highlights = {
          enabled = true;
          groups = [
            "BlinkPairsOrange"
            "BlinkPairsPurple"
            "BlinkPairsBlue"
          ];
          matchparen = {
            enabled = true;
            group = "MatchParen";
          };
        };
        debug = false;
      };
    };
  };
}
