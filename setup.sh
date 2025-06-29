#!/usr/bin/env fish

### change display_resolution
sed -i 's/^\(monitor =[^,]*, preferred, auto,\) 1$/\1 1.8/' ~/.config/hypr/config/monitor.conf


### change directory_name
LANG=C xdg-user-dirs-update --force

### AUR（Arch User Repository）サポートツール
sudo pacman -S yay

### copy & paste
sudo pacman -S wl-clipboard

### capslock -> left Ctrl, touchpad scroll

grep -q 'kb_options = ctrl:nocaps' ~/.config/hypr/hyprland.conf; or echo -e '\ninput {\n    kb_options = ctrl:nocaps\n\n    touchpad {\n        natural_scroll = true\n    }\n}' >> ~/.config/hypr/hyprland.conf

### install mozc
sudo pacman -S fcitx5 fcitx5-mozc fcitx5-gtk fcitx5-qt
sudo pacman -S fcitx5-configtool

echo -e '\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIER=@im=fcitx\nexport INPUT_METHOD=fcitx\nexport SDL_IM_MODULE=fcitx\nexport GLFW_IM_MODULE=fcitx' >> ~/.profile

### add `.config/hypr/hyprland.conf`
grep -q 'exec-once *= *fcitx5' ~/.config/hypr/hyprland.conf; or echo 'exec-once = fcitx5' >> ~/.config/hypr/hyprland.conf

### set mozc
### fcitx5-configtool


### install google-chrome, ranger

sudo pacman -S ranger
ranger --copy-config all
sed -i 's/^set show_hidden false$/set show_hidden true/' ~/.config/ranger/rc.conf

paru -S google-chrome

### Display in Japanese
sudo pacman -S noto-fonts noto-fonts-cjk
yay -S ttf-mplus

### fontconfigでフォントの優先順位を変更
mkdir -p ~/.config/fontconfig

echo '<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="pattern">
    <edit name="family" mode="prepend">
      <string>Noto Sans Mono CJK JP</string>
      <string>Noto Sans CJK JP</string>
    </edit>
  </match>
</fontconfig>' > ~/.config/fontconfig/fonts.conf


fc-cache -fv

### kitty setting
sudo pacman -S kitty xdg-desktop-portal xdg-desktop-portal-hyprland

paru -S ttf-hackgen

cp ~/.config/ranger/rc.conf ~/.config/ranger/rc.conf.bak
sed -i 's/^set preview_images false$/set preview_images true/' ~/.config/ranger/rc.conf
sed -i 's/^set preview_images_method w3m$/set preview_images_method kitty/' ~/.config/ranger/rc.conf

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip
fc-cache -fv
cd $HOME

mkdir -p ~/.config/kitty; echo '
# ──────────────── フォント ────────────────
# font_family      Noto Sans Mono CJK JP
font_family      HackGen Console
font_size        11.5

# ──────────────── ウィンドウ ────────────────
background_opacity 0.9
initial_window_width 100c
initial_window_height 30c

# ──────────────── 色 ────────────────
background #2E3440
foreground #D8DEE9

color0  #3B4252
color1  #BF616A
color2  #A3BE8C
color3  #EBCB8B
color4  #81A1C1
color5  #B48EAD
color6  #88C0D0
color7  #E5E9F0

color8  #4C566A
color9  #BF616A
color10 #A3BE8C
color11 #EBCB8B
color12 #81A1C1
color13 #B48EAD
color14 #8FBCBB
color15 #ECEFF4

# ──────────────── カーソル ────────────────
cursor_shape underline
cursor_blink_interval 0.6

# ──────────────── マウス・選択 ────────────────
copy_on_select yes
mouse_hide_wait 1.0

# ──────────────── スクロール ────────────────
scrollback_lines 10000

# ──────────────── キーバインド ────────────────
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map shift+page_up scroll_page_up
map shift+page_down scroll_page_down
map ctrl+0 change_font_size all 0

# ──────────────── その他 ────────────────
allow_remote_control yes
' > ~/.config/kitty/kitty.conf

