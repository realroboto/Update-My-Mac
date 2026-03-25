#!/bin/bash
sudo -S purge &&
sudo ifconfig awdl0 down
sudo -u $USER brew analytics off
sudo -u $USER brew update &&
sudo -u $USER brew upgrade &&
sudo -u $USER brew update &&
sudo -u $USER brew list | xargs brew install &&
sudo -u $USER brew cleanup --prune=all &&
sudo -u $USER brew tap --repair &&
sudo -u $USER brew autoremove &&
sudo -S dscacheutil -flushcache &&
sudo -S killall -HUP mDNSResponder &&
echo "" > /Users/$USER/.ssh/known_hosts &&
#sudo -S softwareupdate -i -a -R --agree-to-license --verbose 
#sudo scutil --set ComputerName M1 &&
#sudo scutil --set LocalHostName M1 &&
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/exclusive
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-shm
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-wal
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/resetreason
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.data
#sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
chflags nohidden ~/Library
defaults write NSGlobalDomain AppleShowAllExtensions -bool true


# Desabilita o controle de AutoFill que causa lag
#defaults write -g NSAutoFillHeuristicControllerEnabled -bool false

# Desabilita shadow rendering que causa alto uso de GPU
#launchctl setenv CHROME_HEADLESS 1

#Acelerar Animações do Finder
#defaults write com.apple.finder DisableAllAnimations -bool true


# Desabilita animações
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
#defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
#defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

killall Finder
killall SystemUIServer
killall Dock
