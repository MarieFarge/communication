#!/bin/bash

# compile markdown file "$1" to HTML file "$2",
# with header "$3" and footer "$4"
# checking for errors

IN="$1"
OUT="$2"
HEAD="$3"
FOOT="$4"
DIR=$(dirname "$OUT")

function checkhtml () {
  tidy -utf8 -errors -xml -quiet "$1"
  A=$?
  if [ $A -ne 0 ]
  then
  exit $A
  fi
  cat -n "$1" | grep --color '< '
  A=$?
  if [ $A -ne 0 ]
  then
  exit 0
  else
  exit 1
  fi
}

mkdir -p "$DIR"

echo "Compiling $OUT"
python -m markdown  -x markdown.extensions.toc "$IN" |
  cat "$HEAD" - "$FOOT" > "$OUT"
checkhtml "$OUT" || {
  echo "Error when validating $OUT" ;
  exit 1;
}

