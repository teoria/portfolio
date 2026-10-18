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
has cv/index.html     '<li>MLOps, data quality and data governance.</li>'

# Posts (drafts are fixtures)
has index.html                  'posts/example/'
has posts/example/index.html    'linkedin.com/posts'
has pt/posts/example/index.html '<html lang="?pt'
has posts/only-en/index.html    'Only in English'
has posts/only-en/index.html    'href="?/pt/"?'
has posts/index.html            'posts/example/'

# Empty state: no drafts
build
has index.html    'No posts yet'
has pt/index.html 'Nenhuma publicação ainda'

# Repos, offline (API unavailable must not break the build)
GITHUB_FETCH=false build
has projects/index.html       'No projects yet'
has experiments/index.html    'gohugoio/hugo'
has experiments/index.html    'class="card repo-card'
has pt/experiments/index.html 'Experimentos'

# Production build + CV PDFs
GITHUB_FETCH=false bash scripts/build.sh >/dev/null
pdf() { pdftotext "public/$1" - 2>/dev/null; }
pdf cv.pdf    | grep -q 'Serasa Experian'   || { echo "FAIL: cv.pdf content"; exit 1; }
pdf pt/cv.pdf | grep -q 'Carreira anterior' || { echo "FAIL: pt/cv.pdf content"; exit 1; }
! pdf cv.pdf  | grep -q 'Experiments'       || { echo "FAIL: nav printed in cv.pdf"; exit 1; }
! pdf cv.pdf  | grep -qiE 'gmail|midiaseducativas' || { echo "FAIL: private contact in cv.pdf"; exit 1; }
echo OK
