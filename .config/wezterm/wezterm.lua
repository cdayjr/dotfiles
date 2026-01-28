local wezterm = require 'wezterm'
config = {
  color_scheme = 'Brogrammer',
  enable_tab_bar = true,
  font = wezterm.font 'ComicCodeLigatures Nerd Font Mono',
  font_size = 24.0,
  hide_tab_bar_if_only_one_tab = true,
  initial_cols = 80,
  initial_rows = 16,
}
if wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin' then
  config.front_end = 'WebGpu'
end
return config
