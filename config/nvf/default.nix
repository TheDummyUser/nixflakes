{config, ...}: {
  programs.nvf = {
    enable = true;
    settings = {
      #  vim.theme.enable = true;
      #  vim.theme.name = "gruvbox";
      #  vim.theme.style = "dark";

      vim.theme = {
        enable = true;
        name = "base16";
        base16-colors = {
          base00 = "#${config.colorScheme.palette.base00}"; # Background color, usually the darkest shade for primary content
          base01 = "#${config.colorScheme.palette.base01}"; # Slightly lighter background, used for secondary sections or panels
          base02 = "#${config.colorScheme.palette.base02}"; # Used for borders or subtle highlights
          base03 = "#${config.colorScheme.palette.base03}"; # Lighter color for muted text or UI elements
          base04 = "#${config.colorScheme.palette.base04}"; # Additional lighter color for secondary text
          base05 = "#${config.colorScheme.palette.base05}"; # Default Lualine & default foreground color for text
          base06 = "#${config.colorScheme.palette.base06}"; # Lightest text color, often for highlights
          base07 = "#${config.colorScheme.palette.base07}"; # Pure white, used for maximum contrast or highlights

          base09 = "#${config.colorScheme.palette.base09}"; # Red, often used for errors or warnings
          base08 = "#${config.colorScheme.palette.base08}"; # French blue, used for special highlights or less severe warnings
          base0A = "#${config.colorScheme.palette.base0A}"; # Purple, commonly used for constants, keywords, or special variables
          base0B = "#${config.colorScheme.palette.base0B}"; # LL- insert: Muted Red, typically used for success messages or insert mode
          base0D = "#${config.colorScheme.palette.base0D}"; # LL- visual: Cyan, often used for informational text or hints
          base0C = "#${config.colorScheme.palette.base0C}"; # Yellow, often used for attention-grabbing elements
          base0E = "#${config.colorScheme.palette.base0E}"; # Olive, used for special highlights or emphasis (such as active text)
          base0F = "#${config.colorScheme.palette.base0F}";
        };
      };
      vim.preventJunkFiles = true;

      vim.statusline.lualine.enable = true;
      vim.telescope.enable = true;
      vim.autocomplete.nvim-cmp.enable = true;
      vim.autopairs.nvim-autopairs.enable = true;

      vim.binds.whichKey.enable = true;

      vim.languages = {
        enableLSP = true;
        enableTreesitter = true;
        enableFormat = true;

        nix.enable = true;
        ts.enable = true;
        go.enable = true;
        tailwind.enable = true;
      };
    };
  };
}
