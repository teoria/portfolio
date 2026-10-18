#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
has()   { grep -qE "$2" "public/$1" || { echo "FAIL: $1 lacks /$2/"; exit 1; }; }
lacks() { ! grep -rqiE "$2" "public/$1" || { echo "FAIL: $1 contains /$2/"; exit 1; }; }
build() { rm -rf public && hugo --quiet "$@" >/dev/null; }

build --buildDrafts
has index.html     '<html lang="?en'
has pt/index.html  '<html lang="?pt'
has index.html     'href="?/pt/'
has CNAME          '^rodrigocarneiro.com$'

# CV
has cv/index.html     'Serasa Experian'
has cv/index.html     'Earlier career'
has pt/cv/index.html  'Carreira anterior'
has cv/index.html     'Universidade de Pernambuco'
has index.html        'Download CV'
has index.html        'Rodrigo Carneiro'
lacks . 'gmail|midiaseducativas|teoria@'
echo OK
