# Request to a server, And fetch only the HTTP state code from the response
# $1: request url
function get_status_code(){
  curl -LI -m 10 -o /dev/null -s -w '%{http_code}' $1
}