#!/usr/bin/env bash
# Build the site into public/ and print the CV pages to public/cv.pdf and public/pt/cv.pdf.
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME=${CHROME:-$(command -v google-chrome || command -v chromium || echo "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")}
PORT=${PORT:-$(python3 -c "import socket; s=socket.socket(); s.bind(('127.0.0.1', 0)); print(s.getsockname()[1])")}

rm -rf public
hugo --minify --gc

# Print from a local server, not baseURL, so it works before DNS/deploy exist.
# Mirror baseURL's path (e.g. /portfolio/ on github.io) so root-relative CSS links resolve.
BASEPATH=$(hugo config --format json | python3 -c "import json,sys,urllib.parse; print(urllib.parse.urlparse(json.load(sys.stdin)['baseurl']).path.strip('/'))")
root="$PWD/public"
if [ -n "$BASEPATH" ]; then
  root=$(mktemp -d)
  mkdir -p "$(dirname "$root/$BASEPATH")"
  ln -s "$PWD/public" "$root/$BASEPATH"
fi
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$root" >/dev/null 2>&1 &
server=$!
trap 'kill $server' EXIT
URL="http://127.0.0.1:$PORT/${BASEPATH:+$BASEPATH/}"
for _ in $(seq 50); do curl -sf "$URL" >/dev/null && break; sleep 0.1; done

print() {
  "$CHROME" --headless=new --disable-gpu --no-sandbox --no-pdf-header-footer \
    --print-to-pdf="public/$2" "$URL$1" 2>/dev/null
  test -s "public/$2"
}
print cv/ cv.pdf
print pt/cv/ pt/cv.pdf
