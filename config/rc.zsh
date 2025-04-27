# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/history.zsh

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_all_dups   # Delete old recorded entry if new entry is a duplicate.
setopt hist_find_no_dups      # Do not display a line previously found.
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_reduce_blanks     # Remove superfluous blanks before recording entry.
setopt hist_save_no_dups      # Don't write duplicate entries in the history file.
setopt hist_verify            # show command with history expansion to user before running it
# setopt share_history          # share command history data


# Disable correction
unsetopt correct_all
unsetopt correct
DISABLE_CORRECTION="true"

unsetopt share_history
setopt prompt_subst
unsetopt prompt_cr prompt_sp

# make zsh can use `#` in interactive shell
setopt interactivecomments
# make `?` in string not need for quote
setopt no_nomatch

export HISTCONTROL='ignoreboth';

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';