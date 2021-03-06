#!/usr/bin/env sh

# dock preferences
#defaults write com.apple.dock pinning -string end

# Disable menu bar transparency
#defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# restart Dock
#killall Dock

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Do not launch xterm by default when X11 is started
defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
