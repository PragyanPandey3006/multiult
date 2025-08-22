#!/bin/bash

# Advanced Multi-Instance Ultroid Deployment Script
echo "🚀 Advanced Multi-Instance Ultroid Deployment"
echo "============================================="

# Configuration
INSTANCES=2
BASE_NAME="ultroid"
BASE_DIR=$(pwd)

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found! Please run setup first."
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found! Please create it first."
    exit 1
fi

# Stop any existing instances
echo "🧹 Cleaning up existing instances..."
for i in $(seq 1 $INSTANCES); do
    screen_name="${BASE_NAME}_${i}"
    screen -S $screen_name -X quit 2>/dev/null
done

# Clean up any remaining processes
pkill -f "python3 -m pyUltroid" 2>/dev/null
sleep 3

# Create instance directories and copy necessary files
echo "📁 Setting up instance directories..."
for i in $(seq 1 $INSTANCES); do
    instance_dir="instance${i}"
    
    # Create directory if it doesn't exist
    mkdir -p "$instance_dir"
    
    # Copy necessary files (but not session files to avoid conflicts)
    cp -r pyUltroid "$instance_dir/" 2>/dev/null || true
    cp -r plugins "$instance_dir/" 2>/dev/null || true
    cp -r strings "$instance_dir/" 2>/dev/null || true
    cp -r resources "$instance_dir/" 2>/dev/null || true
    cp requirements.txt "$instance_dir/" 2>/dev/null || true
    cp .env "$instance_dir/" 2>/dev/null || true
    
    # Clean any existing session files in instance directory
    rm -f "$instance_dir"/*.session* 2>/dev/null
done

# Start instances
echo "🔄 Starting $INSTANCES instances..."

# Instance 1 (Main instance)
echo "🚀 Starting Instance 1 in screen: ${BASE_NAME}_1"
screen -dmS "${BASE_NAME}_1" bash -c "
    cd '$BASE_DIR/instance1'
    source '../venv/bin/activate'
    echo '🤖 Ultroid Instance 1 starting in $(pwd)...'
    python3 -m pyUltroid
"

# Wait before starting second instance
sleep 8

# Instance 2 (Secondary instance)
echo "🚀 Starting Instance 2 in screen: ${BASE_NAME}_2"
screen -dmS "${BASE_NAME}_2" bash -c "
    cd '$BASE_DIR/instance2'
    source '../venv/bin/activate'
    # Override environment variables for second instance
    export API_ID=\$(grep '^API_ID1=' ../.env | cut -d'=' -f2)
    export API_HASH=\$(grep '^API_HASH1=' ../.env | cut -d'=' -f2)
    export SESSION=\$(grep '^SESSION1=' ../.env | cut -d'=' -f2)
    export MONGODBNAME=\$(grep '^MONGODBNAME1=' ../.env | cut -d'=' -f2)
    echo '🤖 Ultroid Instance 2 starting in $(pwd)...'
    echo 'Using API_ID: '\$API_ID
    echo 'Using MONGODBNAME: '\$MONGODBNAME
    python3 -m pyUltroid
"

# Wait for sessions to initialize
echo "⏳ Waiting for instances to initialize..."
sleep 15

# Check status
echo ""
echo "📊 Deployment Status:"
echo "===================="

running_count=0
for i in $(seq 1 $INSTANCES); do
    screen_name="${BASE_NAME}_${i}"
    if screen -list | grep -q $screen_name; then
        echo "✅ Instance $i: Running ($screen_name)"
        ((running_count++))
    else
        echo "❌ Instance $i: Failed to start"
    fi
done

echo ""
echo "🎯 Summary: $running_count/$INSTANCES instances running"
echo ""
echo "📱 Screen Sessions:"
screen -ls

echo ""
echo "🔍 Python Processes:"
ps aux | grep "python3 -m pyUltroid" | grep -v grep | wc -l | xargs echo "processes running"

echo ""
echo "🔧 Management Commands:"
echo "  View all sessions: screen -ls"
echo "  Attach to instance 1: screen -r ${BASE_NAME}_1"
echo "  Attach to instance 2: screen -r ${BASE_NAME}_2"
echo "  Detach from session: Ctrl+A then D"
echo "  Stop all instances: bash multi_stop.sh"
echo ""
echo "✅ Advanced multi-instance deployment completed!"
