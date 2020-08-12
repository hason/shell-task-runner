#!/bin/sh
. "$(dirname "$0")/../runner"

set +e
trap - EXIT

_text=""
_value=""

scenario(){
  _text="$1"
}

output(){
  _value="$("$@")"
}

should()(
  "$@"
)

be()(
  "$@"
)

equal()(
  diff="$(_diff "$1" "$_value")"
  [ $? -eq 0 ] && _pass "$_text" || _fail "$_text" || echo "$diff" | _indent
)

ps -p $$
echo "$SHELL"
if [[ "x" = "x" ]]; then echo "bash"; fi

scenario Red
  output _ansi --red "Red color"
  should be equal "$(printf "\e[31m%s\e[39m" "Red color")"

scenario "Ansifilter"
  output _ansifilter "$(printf "\e[31m%s\e[39m color" "Red")"
  should be equal "Red color"

scenario "Bold"
  output _ansi --bold "Bold text"
  should be equal "$(printf "\e[1m%s\e[22m" "Bold text")"
