#!/usr/bin/env bash
set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/keyboard-mouse"
ACTIVE_FILE="$STATE_DIR/active"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DAEMON="$SCRIPT_DIR/keyboard-mouse-daemon.py"
UI="$SCRIPT_DIR/keyboard-mouse-ui.py"
PID_FILE="$STATE_DIR/daemon.pid"

mkdir -p "$STATE_DIR"

start_daemon() {
    if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        return 0
    fi
    rm -f "$PID_FILE"
    nohup python3 "$DAEMON" >>/tmp/keyboard-mouse-daemon.log 2>&1 &
    echo $! > "$PID_FILE"
    sleep 0.2
    if ! kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "Daemon başlatılamadı. Log:"
        cat /tmp/keyboard-mouse-daemon.log
        rm -f "$PID_FILE"
        return 1
    fi
}

stop_daemon() {
    if [[ -f "$PID_FILE" ]]; then
        pid="$(cat "$PID_FILE")"
        kill "$pid" 2>/dev/null || true
        rm -f "$PID_FILE"
    fi

    # Eski/elle başlatılmış daemon'ları da kapat.
    # Böylece eski config kullanan ikinci bir daemon End/Ctrl+End gibi
    # tuşlara cevap vermeye devam edemez.
    while read -r pid; do
        [[ -n "$pid" ]] || continue
        kill "$pid" 2>/dev/null || true
    done < <(pgrep -f '[k]eyboard-mouse-daemon\.py' 2>/dev/null || true)

    sleep 0.15
}

case "${1:-}" in
    daemon)
        start_daemon
        ;;
    start)
        start_daemon || exit 1
        touch "$ACTIVE_FILE"

        # Bildirimi daemon verir:
        # - Mod açıldıysa sadece CLOSE kombinasyonunu gösterir.
        # - Mod kapandıysa sadece OPEN kombinasyonunu gösterir.
        ;;
    stop)
        rm -f "$ACTIVE_FILE"
        ;;
    settings|config)
        exec python3 "$UI"
        ;;
    left-click) ydotool click 0xC0 ;;
    middle-click) ydotool click 0xC2 ;;
    right-click) ydotool click 0xC1 ;;
    restart-daemon)
        stop_daemon
        start_daemon
        ;;
    *)
        echo "Usage: $0 {daemon|start|stop|settings|left-click|middle-click|right-click|restart-daemon}"
        exit 1
        ;;
esac
