#!/usr/bin/env fish

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

set profile_file ~/.profile

# 追記する内容
set lines '
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIER=@im=fcitx
export INPUT_METHOD=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx
'

# 含まれていない場合のみ追記
if not grep -q 'GTK_IM_MODULE=fcitx' $profile_file
    echo $lines >> $profile_file
    echo "✅ Fcitx環境変数を .profile に追記しました"
else
    echo "ℹ️ 既に .profile に設定があります（追記しませんでした）"
end

### add `.config/hypr/hyprland.conf`
grep -q 'exec-once *= *fcitx5' ~/.config/hypr/hyprland.conf; or echo 'exec-once = fcitx5' >> ~/.config/hypr/hyprland.conf

### set mozc
### fcitx5-configtool


### install google-chrome, ranger

sudo pacman -S ranger
ranger --copy-config all
sed -i 's/^set show_hidden false$/set show_hidden true/' ~/.config/ranger/rc.conf

paru -S google-chrome



