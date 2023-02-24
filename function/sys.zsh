# ref: https://github.com/paulmillr/dotfiles/blob/master/home/.zshrc.sh
function _calc_ram() {
  local sum
  sum=0
  for i in $(ps aux | rg -i "$1" | rg -v "rg" | awk '{print $6}'); do
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