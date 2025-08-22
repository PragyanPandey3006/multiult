#!/usr/bin/env bash
# Monitor All Ultroid Instances
# Created by @pragyan for multi-instance monitoring

echo "📊 Ultroid Multi-Instance Status by @pragyan"
echo "============================================="

running_count=0

for i in {1..5}; do
    session_name="ultroid_instance_$i"
    if screen -list | grep -q "$session_name"; then
        echo "✅ Instance $i: RUNNING"
        ((running_count++))
    else
        echo "❌ Instance $i: STOPPED"
    fi
done

echo ""
echo "Summary: $running_count/5 instances running"
echo ""
echo "Active screen sessions:"
screen -ls | grep ultroid_instance || echo "No Ultroid instances running"

echo ""
echo "Commands:"
echo "- Attach to instance: screen -r ultroid_instance_1"
echo "- Stop all instances: bash stop_all.sh"
echo "- Restart all: bash startup"
echo ""
echo "Multi-Instance system by @pragyan"
