{ pkgs, ... }: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "ayu_dark";

      editor = {
        mouse = false;
        line-number = "relative";
        auto-completion = true;
        auto-format = true;
        true-color = true;
        bufferline = "multiple";
        auto-pairs = true;
        popup-border = "all";

        statusline = {
          left = [ "mode" "spinner" "file-name" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
        lsp = {
          enable = true;
          display-messages = true;
          display-inlay-hints = true;
          snippets = true;
          goto-reference-include-declaration = true;
        };
        #search = {
        #  smart-case = true;
        #  warp-around = true;
        #};

        whitespace = {
          render = "all";

          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·"; # Tabs will look like "→···" (depending on tab wid
          };
        };

        indent-guides = {
          render = true;
          character = "▏"; # Some characters that work well: "▏", "┆", "┊", "⸽"
          skip-levels = 1;
        };

      };

    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
      }

      {
        name = "python";
        language-servers = [ "pylsp" ];
        auto-format = true;
        #languages-server.pylsp.config.pylsp = {
        #  plugins.pylsp_mypy.enabled = true;
        #  plugins.pylsp_mypy.live_mode = true;
        #};
      }

      {
        name = "go";
        auto-format = true;
        formatter.command = "goimports";
      }

      {
        name = "javascript";
        auto-format = true;
        language-servers =
          [ "typescript-language-server" "vscode-eslint-language-server" ];
      }

      {
        name = "typescript";
        auto-format = true;
        language-servers =
          [ "typescript-language-server" "vscode-eslint-language-server" ];
      }
      {
        name = "html";
        auto-format = true;
        language-servers = [ "vscode-html-language-server" "tailwindcss-ls" ];
      }

      {
        name = "css";
        auto-format = true;
        language-servers = [ "vscode-html-language-server" "tailwindcss-ls" ];
      }

      {
        name = "jsx";
        auto-format = true;
        language-servers = [ "vscode-html-language-server" "tailwindcss-ls" ];
      }

      {
        name = "tsx";
        auto-format = true;
        language-servers = [ "vscode-html-language-server" "tailwindcss-ls" ];
      }
    ];
  };
}
