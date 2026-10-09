#!/bin/bash
# usage: run.sh <scratch-dir> <logprefix>
EXE="$1/EIFGENs/spike_b2/F_code/spike_b2.exe"; OUT="$2"; U=http://127.0.0.1:18084
"$EXE" > "$OUT.ticks.txt" 2>&1 &
BP=$!; WP=$(cat /proc/$BP/winpid 2>/dev/null); echo "win_pid=$WP"
for i in $(seq 1 40); do curl -s -m 1 -o /dev/null $U/fast && break; sleep 0.25; done
{
echo "--- fast alone x5"; for i in 1 2 3 4 5; do curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" $U/fast; done
echo "--- /r20 (last route)"; curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" $U/r20
echo "--- 20 parallel fast"; for i in $(seq 1 20); do curl -s -m 20 -o /dev/null -w "%{http_code}\n" $U/fast & done | sort | uniq -c; wait
echo "--- fast during slow"
curl -s -m 20 -o /dev/null -w "slow: %{http_code} %{time_total}s\n" $U/slow &
sleep 0.4
curl -s -m 20 -o /dev/null -w "fast-during-slow: %{http_code} %{time_total}s\n" $U/fast
wait
echo "--- 5 fast + 5 slow wall"; S=$(date +%s%N)
for i in 1 2 3 4 5; do curl -s -m 60 -o /dev/null -w "fast %{http_code} %{time_total}s\n" $U/fast & curl -s -m 60 -o /dev/null -w "slow %{http_code} %{time_total}s\n" $U/slow & done
wait; E=$(date +%s%N); echo "wall: $(( (E - S)/1000000 )) ms"
} 2>&1 | tee "$OUT.curl.txt"
powershell -NoProfile -Command "Stop-Process -Id $WP -Force" && echo "stopped $WP"
