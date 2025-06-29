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



