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
lacks cv/index.html   'Redshift|lakehouse|teams trust|Core data engineering'
has cv/index.html     '<li>MLOps, data quality and data governance.</li>'

# Posts (drafts are fixtures)
has index.html                  'posts/example/'
has posts/example/index.html    'linkedin.com/posts'
has pt/posts/example/index.html '<html lang="?pt'
has posts/only-en/index.html    'Only in English'
has posts/only-en/index.html    'href="?/pt/"?'
has posts/index.html            'posts/example/'

# Real posts, no drafts
build
has index.html    'posts/data-contracts-ai/'
has pt/index.html 'pt/posts/data-contracts-ai/'
lacks index.html  'posts/example/'
has posts/duckdb-threads/index.html    'Excerpt. The full post is on LinkedIn'
has pt/posts/duckdb-threads/index.html 'Trecho. O post completo'
has posts/index.html 'posts/dbt-docs-in-airflow-cosmos/'
has posts/airflow-embedash/index.html    'class="post-images'
has pt/posts/airflow-embedash/index.html 'airflow-embedash/image-3.jpg'

# Repos, offline (API unavailable must not break the build)
GITHUB_FETCH=false build
has projects/index.html       'teoria/airflow-embedash'
has experiments/index.html    'teoria/quacklake'
has experiments/index.html    'class="card repo-card'
has pt/experiments/index.html 'Experimentos'

# Phone: compact sidebar so posts sit near the top
awk '/@media \(max-width: 760px\)/{m=1} m&&/\.sidebar \.plain/{f=1} /^}/{m=0} END{exit !f}' assets/css/main.css || { echo "FAIL: sidebar not compact on phones"; exit 1; }

# Production build + CV PDFs
GITHUB_FETCH=false bash scripts/build.sh >/dev/null
pdf() { pdftotext "public/$1" - 2>/dev/null; }
pdf cv.pdf    | grep -q 'Serasa Experian'   || { echo "FAIL: cv.pdf content"; exit 1; }
pdf pt/cv.pdf | grep -q 'Carreira anterior' || { echo "FAIL: pt/cv.pdf content"; exit 1; }
! pdf cv.pdf  | grep -q 'Experiments'       || { echo "FAIL: nav printed in cv.pdf"; exit 1; }
! pdf cv.pdf  | grep -qiE 'gmail|midiaseducativas' || { echo "FAIL: private contact in cv.pdf"; exit 1; }

# CI deploys every push: placeholders must never ship
if [ -n "${CI:-}" ]; then lacks . 'github\.com/OWNER|gohugoio/hugo'; fi
echo OK
