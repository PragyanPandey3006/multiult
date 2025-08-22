#!/bin/bash

# Ultroid Multi-Instance Management Script
# Usage: ./ultroid.sh [start|stop|status|restart]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

case "$1" in
    start)
        echo "🚀 Starting Ultroid Multi-Instance Deployment..."
        bash ultroid_deploy.sh
        ;;
    stop)
        echo "🛑 Stopping All Ultroid Instances..."
        bash ultroid_stop.sh
        ;;
    status)
        echo "📊 Checking Ultroid Instance Status..."
        bash ultroid_status.sh
        ;;
    restart)
        echo "🔄 Restarting All Ultroid Instances..."
        bash ultroid_stop.sh
        sleep 3
        bash ultroid_deploy.sh
        ;;
    *)
        echo "🤖 Ultroid Multi-Instance Manager"
        echo "================================"
        echo "Usage: $0 {start|stop|status|restart}"
        echo ""
        echo "Commands:"
        echo "  start   - Deploy and start all instances"
        echo "  stop    - Stop all running instances"
        echo "  status  - Check status of all instances"
        echo "  restart - Stop and restart all instances"
        echo ""
        echo "Screen Management:"
        echo "  View sessions: screen -ls"
        echo "  Attach to instance 1: screen -r ultroid_1"
        echo "  Attach to instance 2: screen -r ultroid_2"
        echo "  Detach: Ctrl+A then D"
        exit 1
        ;;
esac
