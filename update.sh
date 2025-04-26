#!/bin/bash
sudo -S purge &&
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
sudo -S purge &&
echo "" > /Users/$USER/.ssh/known_hosts &&
#sudo -S softwareupdate -i -a -R --agree-to-license --verbose 
sudo scutil --set ComputerName M1
sudo scutil --set LocalHostName M1
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/exclusive
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-shm
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/index.sqlite-wal
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/resetreason
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.data
sudo rm -rfv $(getconf DARWIN_USER_CACHE_DIR)/com.apple.QuickLook.thumbnailcache/thumbnails.fraghandler
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.finder AppleShowAllFiles -bool true
chflags nohidden ~/Library
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
