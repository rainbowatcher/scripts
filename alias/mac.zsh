#!/usr/bin/env bash

alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
alias spotlightoff="sudo mdutil -a -i off"
alias spotlighton="sudo mdutil -a -i on"
