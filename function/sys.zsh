# ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
function _calc_ram() {
  local sum
  sum=0
  local grep_cmd=`alias grep | sed "s/.*'\(.*\)'.*/\1/"`
  for i in $(ps aux | grep -i "$1" | grep -v "$grep_cmd -i $1" | awk '{print $6}'); do
    sum=$(($i + $sum))
  done
  sum=$(echo "scale=2; $sum / 1024.0" | bc)
  echo $sum
}

function ram() {
  local app="$*"
  local sum=$(_calc_ram $app)
  if [[ $sum != "0" ]]; then
    echo "${BLUE}${app}${FONT} uses ${GREEN}${sum}${FONT} MBs of RAM"
  else
    echo "No active processes matching pattern '${BLUE}${app}${FONT}'"
  fi
}

# display target dir disk usage statistics in humen readable sort
# $1: target dir
function dud() {
  local target=$1
  du -hd1 $target | sort -h
}

# display all file disk usage statistics in humen readable sort
function dua() {
  local target=$1
  du -ahd1 $target | sort -h
}

# display node_modules disk usage statistics in humen readable sort
function dun() {
  if test -d "node_modules/.pnpm"; then
    dud "node_modules/.pnpm"
  elif test -d "node_modules"; then
    dud "node_modules"
  else
    warn "node_modules not found."
  fi
}
