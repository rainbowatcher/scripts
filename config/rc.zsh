#!/usr/bin/env zsh

# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found.
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry.
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file.
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt SHARE_HISTORY          # share command history data


# Disable zsh correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"

# unsetopt share_history

# zsh prompt
# setopt prompt_subst
# unsetopt prompt_cr prompt_sp

# make zsh can use `#` in interactive shell
setopt interactivecomments
# make `?` in string not need for quote
setopt no_nomatch

# delete duplicate history and ignore command start with whitespace, option: `ignorespace` | `erasedups` | `ignoreboth`
HISTCONTROL='ignoreboth';
# Highlight section titles in manual pages.
LESS_TERMCAP_md="${yellow}";
# Don’t clear the screen after quitting a manual page.
MANPAGER='less -X';

# zsh tab completion case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

EDITOR="vim"
BAT_THEME="TwoDark"
TERM=xterm-256color