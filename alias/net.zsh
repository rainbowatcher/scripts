# IP addresses
alias public_ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local_ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -oE 'inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)|[a-fA-F0-9:]+)' | awk '{sub(/inet6? (addr:)? ?/, \"\"); print}'"

[ ! is_callable curl ] && return
# Request to a server, And fetch only the HTTP state code from the response
# $1: request url
alias status_code="curl -LI -m 10 -o /dev/null -s -w '%{http_code}'"
