function get_status_code(){
  curl -LI -m 10 -o /dev/null -s -w %{http_code} $1
}