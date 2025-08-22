#!/bin/bash

# Ultroid Stop Script
echo "🛑 Stopping All Ultroid Instances"
echo "================================="

INSTANCES=2
stopped_count=0

for i in $(seq 1 $INSTANCES); do
    screen_name="ultroid_${i}"
    echo "🛑 Stopping Instance $i ($screen_name)..."
    
    if screen -list | grep -q $screen_name; then
        screen -S $screen_name -X quit
        echo "✅ Instance $i stopped"
        ((stopped_count++))
    else
        echo "ℹ️  Instance $i was not running"
    fi
done

# Clean up any remaining processes
echo "🧹 Cleaning up remaining processes..."
pkill -f "python3 -m pyUltroid" 2>/dev/null

sleep 2

echo ""
echo "🎯 Summary: $stopped_count instances stopped"
echo ""
echo "📱 Remaining Screen Sessions:"
screen -ls 2>/dev/null || echo "No screen sessions found"
echo ""
echo "✅ Cleanup completed!"
