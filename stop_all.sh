#!/usr/bin/env bash
# Stop All Ultroid Instances
# Created by @pragyan for multi-instance deployment

echo "🛑 Stopping all Ultroid instances..."

for i in {1..5}; do
    session_name="ultroid_instance_$i"
    if screen -list | grep -q "$session_name"; then
        screen -S "$session_name" -X quit
        echo "✅ Stopped Instance $i"
    else
        echo "⚠️  Instance $i not running"
    fi
done

echo "🎉 All instances stopped by @pragyan script!"
