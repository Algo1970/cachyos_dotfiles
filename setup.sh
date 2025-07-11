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

### wallpaper setting
paru -S rust
paru -S swww-git
paru -S rofimoji
sudo pacman -S zenity

#paru -S azote
echo -e '\nexec-once = ~/.config/hypr/scripts/restore_wallpaper.sh\nbind = CTRL ALT, E, exec, rofimoji --selector wofi --clipboarder wl-copy --action copy' >> ~/.config/hypr/hyprland.conf


#mkdir -p ~/.config/hypr/scripts
echo '#!/bin/bash

SAVE_FILE="$HOME/.config/hypr/last_wallpaper"

[ ! -f "$SAVE_FILE" ] && exit 0

WALLPAPER=$(cat "$SAVE_FILE")

[ ! -f "$WALLPAPER" ] && exit 0

pidof swww-daemon >/dev/null || swww-daemon &
sleep 0.2
swww img "$WALLPAPER" --transition-type grow' > ~/.config/hypr/scripts/restore_wallpaper.sh

chmod +x ~/.config/hypr/scripts/restore_wallpaper.sh

echo -e '\nbind = $mainMod, W, exec, ~/.config/hypr/scripts/set_wallpaper.sh' >> ~/.config/hypr/hyprland.conf

# mkdir -p ~/.config/hypr/scripts

tee ~/.config/hypr/scripts/set_wallpaper.sh > /dev/null << 'EOF'
#!/bin/bash

# 壁紙フォルダと保存先
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SAVE_FILE="$HOME/.config/hypr/last_wallpaper"

mkdir -p "$(dirname "$SAVE_FILE")"

# Zenityでファイル選択（画像のみフィルター）
SELECTED=$(zenity --file-selection \
  --filename="$WALLPAPER_DIR/" \
  --file-filter="画像ファイル | *.jpg *.jpeg *.png *.webp" \
  --title="壁紙を選んでください")

# キャンセルされた場合は終了
[ -z "$SELECTED" ] && exit 1

# 選んだファイルを保存
echo "$SELECTED" > "$SAVE_FILE"

# swww-daemon 起動していなければ起動
pidof swww-daemon >/dev/null || swww-daemon &

sleep 0.2

# 壁紙を設定
swww img "$SELECTED" --transition-type grow
EOF

chmod +x ~/.config/hypr/scripts/set_wallpaper.sh

### waybar setting
sudo pacman -S lm_sensors
sudo sensors-detect
sudo pacman -S pavucontrol

### copy config , style.css

killall waybar; waybar &

### login theme setting
sudo pacman -S greetd greetd-tuigreet
sudo sed -i 's|command = "agreety --cmd /bin/sh"|command = "tuigreet --cmd Hyprland --user-menu --time --asterisks"|' /etc/greetd/config.toml

### usernameをalgoにする！！
sudo systemctl disable sddm
sudo systemctl stop sddm

# sudo rm /etc/systemd/system/display-manager.service
sudo systemctl enable greetd
sudo systemctl start greetd

### install R
sudo pacman -S r
R --quiet -e 'install.packages(c("tidyverse", "languageserver", "data.table"), repos="https://cloud.r-project.org")'

### install ipython
sudo pacman -S ipython

### install pfetch
cargo install pfetch

echo 'set -l cargobin $HOME/.cargo/bin
if not contains $cargobin $PATH
    set -gx PATH $PATH $cargobin
end' > ~/.config/fish/conf.d/cargo-path.fish

exec fish

### install nvim
yay -S neovim-nightly-bin

### install lualocks
sudo pacman -S python-pipx
pipx ensurepath
pipx install hererocks
exec fish
hererocks ~/.local/share/nvim/lazy-rocks --lua 5.1 --luarocks latest

echo 'set -gx PATH $HOME/.local/share/nvim/lazy-rocks/bin $PATH' >> ~/.config/fish/config.fish

### python3 provider error
python -m venv ~/.venvs/nvim
source ~/.venvs/nvim/bin/activate.fish
pip install pynvim
exit
### init.luaにvim.g.loaded_python3_provider = 0を追加

### Node.js provider error
sudo pacman -S nodejs npm:q
sudo npm install -g neovim

### install fzf
sudo pacman -S fzf

set -Ux EDITOR nvim
set -Ux VISUAL nvim


