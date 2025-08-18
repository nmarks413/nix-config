_: {
  vim = {
    options = {
      linebreak = true;
    };
    git = {
      gitsigns.setupOpts = {
        current_line_blame = false;
        current_line_blame_opts = {
          virt_text = true;
          virt_text_pos = "right_align";
          delay = 25;
          ignore_whitespace = true;
          virt_text_priority = 100;
          use_focus = true;
        };
      };
    };
  };
}
