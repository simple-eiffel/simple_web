#!/bin/bash
# usage: run.sh <exe-dir> <mode: same|split> ; starts the exe itself, stops only that PID
EXE="$1/EIFGENs/spike_a/F_code/spike_a.exe"; MODE="$2"; OUT="$3"
P=18081; U=http://127.0.0.1:$P
"$EXE" $MODE > "$OUT.ticks.txt" 2>&1 &
BP=$!; WP=$(cat /proc/$BP/winpid 2>/dev/null); echo "mode=$MODE bash_pid=$BP win_pid=$WP"
for i in $(seq 1 40); do curl -s -m 1 -o /dev/null $U/fast && break; sleep 0.25; done
{
echo "--- T0 fast alone"; curl -s -m 10 -o /dev/null -w "%{http_code} %{time_total}s\n" $U/fast
echo "--- T3 20 parallel fast only"
for i in $(seq 1 20); do curl -s -m 20 -o /dev/null -w "%{http_code}
" $U/fast & done | sort | uniq -c
wait
echo "--- T1 fast while one slow in flight"
curl -s -m 20 -o /dev/null -w "slow: %{http_code} %{time_total}s\n" $U/slow &
sleep 0.4
curl -s -m 20 -o /dev/null -w "fast-during-slow: %{http_code} %{time_total}s\n" $U/fast
wait
echo "--- T2 20 parallel (5 fast, 5 slow); wall clock total"
S=$(date +%s%N)
for i in $(seq 1 5); do curl -s -m 60 -o /dev/null -w "fast %{http_code} %{time_total}s\n" $U/fast & curl -s -m 60 -o /dev/null -w "slow %{http_code} %{time_total}s\n" $U/slow & done
wait
E=$(date +%s%N); echo "wall: $(( (E - S)/1000000 )) ms"
echo "--- T4 fast 3 s after the burst"; sleep 3; curl -s -m 10 -o /dev/null -w "%{http_code} %{time_total}s
" $U/fast
} 2>&1 | tee "$OUT.curl.txt"
powershell -NoProfile -Command "Stop-Process -Id $WP -Force" && echo "stopped win_pid $WP"
echo "--- ticks (first/last, count)"; head -2 "$OUT.ticks.txt"; tail -1 "$OUT.ticks.txt"; grep -c tick "$OUT.ticks.txt"
