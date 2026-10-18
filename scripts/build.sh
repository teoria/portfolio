#!/usr/bin/env bash
# Build the site into public/ and print the CV pages to public/cv.pdf and public/pt/cv.pdf.
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME=${CHROME:-$(command -v google-chrome || command -v chromium || echo "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")}
PORT=${PORT:-$(python3 -c "import socket; s=socket.socket(); s.bind(('127.0.0.1', 0)); print(s.getsockname()[1])")}

rm -rf public
hugo --minify --gc

# Print from a local server, not baseURL, so it works before DNS/deploy exist.
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory public >/dev/null 2>&1 &
server=$!
trap 'kill $server' EXIT
for _ in $(seq 50); do curl -sf "http://127.0.0.1:$PORT/" >/dev/null && break; sleep 0.1; done

print() {
  "$CHROME" --headless=new --disable-gpu --no-sandbox --no-pdf-header-footer \
    --print-to-pdf="public/$2" "http://127.0.0.1:$PORT/$1" 2>/dev/null
  test -s "public/$2"
}
print cv/ cv.pdf
print pt/cv/ pt/cv.pdf
