#!/usr/bin/env bash

SCRIPTS_ROOT=${SCRIPTS_ROOT:=$(
  cd $(dirname $0)
  pwd
)}

source $SCRIPTS_ROOT/common.zsh

README="$SCRIPTS_ROOT/README.md"

cat >"$README" <<EOM
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

ALIAS_LOCALTION="$SCRIPTS_ROOT/alias"
FILES=($(ls $ALIAS_LOCALTION/*))
for ITEM in "${FILES[@]}"; do
  cat $ITEM |
    sed -n '/^alias [^-]/p' |
    sed "s/\'//g" |
    sed 's/\"//g' |
    sed 's/\|/\\|/g' |
    awk -vitem=$(echo $ITEM | awk -F/ '{name=$NF;split(name,splits,".");print splits[1]}') '
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
  }' >>"$README"
done

cat >>"$README" <<EOM
## Completions

EOM

CMP_LOCALTION="$SCRIPTS_ROOT/completion"
FILES=($(ls $CMP_LOCALTION/*))
for ITEM in "${FILES[@]}"; do
  echo $ITEM | awk -F/ '
  {
    name=$NF;
    split(name,splits,".");
    print "- "splits[1]
  }
  END {
    print ""
  }' >> "$README"
done

cat >>"$README" <<EOM
## Functions

EOM

FUNC_LOCALTION="$SCRIPTS_ROOT/function"
FILES=($(ls $FUNC_LOCALTION/*))
for ITEM in "${FILES[@]}"; do
  cat $ITEM | awk -vitem=$(echo $ITEM | awk -F/ '{name=$NF;split(name,splits,".");print splits[1]}') \
  -F'(' '
  BEGIN{
    num=0;
    print "### " item "\n"
  }
  /\(\)/ {
    num+=1;
    print num ". " $1
  }
  END {
    print ""
  }' >> "$README"
done
