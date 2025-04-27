[ ! is_callable ni ] && return

alias nio="ni --prefer-offline"
alias nid="ni -D"
alias nido="ni -D --prefer-offline"
alias nidw="ni -wD"
alias niw="ni -w"

[ ! is_callable nr ] && return

alias d="nr dev"
alias s="nr start"
alias b="nr build"
alias c="nr clean"
alias l="nr lint"
alias t="nr test"