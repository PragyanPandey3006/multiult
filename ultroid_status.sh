#!/bin/bash

# Ultroid Status Check Script
echo "📊 Ultroid Multi-Instance Status"
echo "==============================="

INSTANCES=2
running_count=0

for i in $(seq 1 $INSTANCES); do
    screen_name="ultroid_${i}"
    if screen -list | grep -q $screen_name; then
        echo "✅ Instance $i: Running ($screen_name)"
        ((running_count++))
    else
        echo "❌ Instance $i: Not running"
    fi
done

echo ""
echo "🎯 Summary: $running_count/$INSTANCES instances running"

# Show Python processes
python_count=$(ps aux | grep "python3 -m pyUltroid" | grep -v grep | wc -l)
echo "🐍 Python processes: $python_count"

echo ""
echo "📱 Screen Sessions:"
screen -ls 2>/dev/null || echo "No screen sessions found"

echo ""
echo "🔧 Quick Commands:"
echo "  Start all: ./ultroid.sh start"
echo "  Stop all: ./ultroid.sh stop"
echo "  Restart: ./ultroid.sh restart"
