#!/usr/bin/env zsh

# support delimiters : '-' '_' ' '
function find_word_delimiter() {
  local str="$1"
  local delimiter=""
  if [[ "$str" == *" "* ]]; then # capital case or no case or sentence case
    delimiter=' '
  elif [[ "$str" == *"-"* ]]; then # header case or param case
    delimiter='\-'
  elif [[ "$str" == *"_"* ]]; then # snake case
    delimiter='_'
  fi
  echo "$delimiter"
}

# not support dot case and path case
# @param $1 origin-string
# @return OriginString
function to_pascal_case() {
  if [[ "$#" -gt 1 ]]; then
    warn "to_pascal_case accept only one parameter."
    return 1
  fi

  local original_string=$1
  local delimiter=$(find_word_delimiter "$original_string")

  if [ $delimiter ]; then
    echo "$original_string" | awk -F"$delimiter" '{OFS = "";
      for(j = 1; j <= NF; j++){
        $j=toupper(substr($j,1,1)) tolower(substr($j,2))
      }
      print
    }'
  else # camel case or pascal case
    echo "$original_string" | awk '{OFS = "";
      s=toupper(substr($0,1,1)) substr($0,2)
      print s
    }'
  fi
}

function to_camel_case() {
  if [[ "$#" -gt 1 ]]; then
    warn "to_pascal_case accept only one parameter."
    return 1
  fi

  local original_string=$1
  local delimiter=$(find_word_delimiter "$original_string")

  if [ $delimiter ]; then
    echo "$original_string" | awk -F"$delimiter" '{OFS = "";
      for(j = 1; j <= NF; j++){
        if (j == 1) {
          $j=tolower(substr($j,1,1)) tolower(substr($j,2))
        } else {
          $j=toupper(substr($j,1,1)) tolower(substr($j,2))
        }
      }
      print
    }'
  else # camel case or pascal case
    echo "$original_string" | awk '{OFS = "";
      s=tolower(substr($0,1,1)) substr($0,2)
      print s
    }'
  fi
}

function to_param_case() {
  if [[ "$#" -gt 1 ]]; then
    warn "to_pascal_case accept only one parameter."
    return 1
  fi

  local original_string=$1
  local delimiter=$(find_word_delimiter "$original_string")

  if [ $delimiter ]; then
    echo "$original_string" | awk -F"$delimiter" '{OFS = "";
      for(j = 1; j <= NF; j++){
        if (j == NF) {
          $j=tolower($j)
        } else {
          $j=tolower($j) "-"
        }
      }
      print
    }'
  else # camel case or pascal case
    echo "$original_string" | awk '{
      head = ""
      tail = $0
      while ( match(tail,/[[:upper:]]/) ) {
        tgt = tolower(substr(tail,RSTART,1))
        if ( substr(tail,RSTART-1,1) ~ /[[:lower:]]/ ) {
            tgt = "_" tolower(tgt)
        }
        head = head substr(tail,1,RSTART-1) tgt
        tail = substr(tail,RSTART+1)
      }
      print head tail
    }'
  fi
}
