#!/bin/bash
# usage: run.sh <scratch-dir> <logprefix>; starts the exe, stops only its own PID
EXE="$1/EIFGENs/adj/F_code/adj.exe"; OUT="$2"; U=http://127.0.0.1:18085; LOG="$1/run/adj.log"
rm -f "$LOG" "$1/run/adj.db"
"$EXE" > "$OUT.ticks.txt" 2>&1 &
BP=$!; WP=$(cat /proc/$BP/winpid 2>/dev/null); echo "win_pid=$WP"
for i in $(seq 1 40); do curl -s -m 1 -o /dev/null $U/fast && break; sleep 0.25; done
{
echo "--- T0 fast alone"; curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" $U/fast
echo "--- T1 one /hit"; curl -s -w " | %{http_code} %{time_total}s\n" "$U/hit?n=0"
echo "--- T2 20 parallel /hit?n=1..20 (log + fresh sqlite connection per request)"
for i in $(seq 1 20); do curl -s -m 20 -w " %{http_code}\n" "$U/hit?n=$i" & done | sort -t= -k2 -n
wait
echo "--- T3 fast while one slow (slow logs) in flight"
curl -s -m 20 -o /dev/null -w "slow: %{http_code} %{time_total}s\n" $U/slow &
sleep 0.4
curl -s -m 20 -o /dev/null -w "fast-during-slow: %{http_code} %{time_total}s\n" "$U/hit?n=99"
wait
echo "--- T4 5 hit + 5 slow parallel; wall"
S=$(date +%s%N)
for i in $(seq 101 105); do curl -s -m 60 -o /dev/null -w "hit %{http_code} %{time_total}s\n" "$U/hit?n=$i" & curl -s -m 60 -o /dev/null -w "slow %{http_code} %{time_total}s\n" $U/slow & done
wait
E=$(date +%s%N); echo "wall: $(( (E - S)/1000000 )) ms"
} 2>&1 | tee "$OUT.curl.txt"
powershell -NoProfile -Command "Stop-Process -Id $WP -Force" && echo "stopped win_pid $WP"
{
echo "--- log file check"
echo "lines: $(wc -l < "$LOG")"
echo "root line: $(grep -c 'root started' "$LOG")"
echo "hit lines: $(grep -c 'hit n=' "$LOG")  slow lines: $(grep -c 'slow begin' "$LOG")"
echo "distinct n in 1..20: $(grep -o 'hit n=[0-9]*$' "$LOG" | sed 's/hit n=//' | awk '$1>=1&&$1<=20' | sort -un | wc -l)"
echo "lines not matching the logger format:"; grep -v '^\[' "$LOG" | head -5
echo "--- first 3 log lines"; head -3 "$LOG"
echo "--- ticks"; head -1 "$OUT.ticks.txt"; grep tick "$OUT.ticks.txt" | tail -1; echo "tick count: $(grep -c '^tick' "$OUT.ticks.txt")"
} 2>&1 | tee "$OUT.check.txt"
