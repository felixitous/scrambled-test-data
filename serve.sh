#!/bin/sh
# Serve this repo as a static site at http://localhost:8765
# Usage: ./serve.sh          (foreground)
#        ./serve.sh start    (background, logs to serve.log)
#        ./serve.sh stop
cd "$(dirname "$0")" || exit 1
PORT=8765

case "${1:-run}" in
  start)
    nohup ./serve.sh run >serve.log 2>&1 &
    echo "serving http://localhost:$PORT (pid $!) — logs in serve.log"
    ;;
  stop)
    pkill -f "http.server $PORT" 2>/dev/null && echo "stopped" || echo "not running"
    ;;
  run)
    exec python3 -m http.server $PORT --bind 127.0.0.1
    ;;
es)
    echo "usage: ./serve.sh [start|stop]" >&2
    exit 1
    ;;
esac
