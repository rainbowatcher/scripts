#!/usr/bin/env bash

SCRIPTS_ROOT=${SCRIPTS_ROOT:=$(
  cd $(dirname $0)
  pwd
)}

source $SCRIPTS_ROOT/common.zsh

readme="$SCRIPTS_ROOT/README.md"

cat >"$readme" <<EOM
# Rainbow Watcher's personal scripts

## Quick Start 

Write it to your \`~/.zshrc\` to enable those scripts.

\`\`\`shell
SCRIPTS_ROOT="/path/to/your/scripts"
# if you want to enable proxy
HTTP_PROXY_ADDR=http://127.0.0.1:8889
source \$SCRIPTS_ROOT/main.zsh all
\`\`\`

## :exclamation: Attension

- Remember to change the proxy port number to you own.
- You must install zoxide, exa, ripgrep, fnm, npm, jq in you compute.

## Alias

EOM

alias_localtion="$SCRIPTS_ROOT/alias"
files=($(ls $alias_localtion/*))
for item in "${files[@]}"; do
  cat $item |
    sed -n '/^alias [^-]/p' |
    sed "s/\'//g" |
    sed 's/\"//g' |
    sed 's/\|/\\|/g' |
    awk -v item=$(echo $item | awk -F/ '{name=$NF;split(name,splits,".");print splits[1]}') '
  BEGIN {
    print "### " item "\n"
  }
  {
    split($0, a, "=");
    split(a[1], b, " ");
    print "- "b[2] ": `" a[2] "`"
  }
  END {
    print ""
  }' >>"$readme"
done

cat >>"$readme" <<EOM
## Completions

EOM

cmp_localtion="$SCRIPTS_ROOT/completion"
files=($(ls $cmp_localtion/*))
for item in "${files[@]}"; do
  echo $item | awk -F/ '
  {
    split($NF, splits, ".");
    print "- " splits[1]
  }
  END {
    print ""
  }' >> "$readme"
done

cat >>"$readme" <<EOM
## Functions

EOM

func_localtion="$SCRIPTS_ROOT/function"
files=($(ls $func_localtion/*))
for item in "${files[@]}"; do
  cat $item | awk -v item=$(echo $item | awk -F/ '{name=$NF;split(name,splits,".");print splits[1]}') \
  -F'(' '
  BEGIN{
    num=0;
    print "### " item "\n"
  }
  /\(\)/ {
    num+=1;
    sub("function ", "", $1)
    print num ". " $1
  }
  END {
    print ""
  }' >> "$readme"
done
