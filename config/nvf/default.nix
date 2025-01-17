{ ... }:
{

  programs.nvf = {
    enable = true;
    settings = {
      #  vim.theme.enable = true;
      #  vim.theme.name = "gruvbox";
      #  vim.theme.style = "dark";


      vim.theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };
       vim.preventJunkFiles = true;


      vim.statusline.lualine.enable = true;
      vim.telescope.enable = true;
      vim.autocomplete.nvim-cmp.enable = true;
      
     vim.binds.whichKey.enable = true;


      vim.languages = {
        enableLSP = true;
        enableTreesitter = true;

        nix.enable = true;
        ts.enable = true;
        go.enable = true;
        tailwind.enable = true;
      };

    };
  };

}
