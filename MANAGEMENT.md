# Ultroid Multi-Instance Management

## Quick Start

### Single Command Management
```bash
./ultroid.sh start    # Start all instances
./ultroid.sh stop     # Stop all instances  
./ultroid.sh status   # Check status
./ultroid.sh restart  # Restart all instances
```

### Screen Session Management
```bash
screen -ls                # List all sessions
screen -r ultroid_1      # Attach to instance 1
screen -r ultroid_2      # Attach to instance 2
# Press Ctrl+A then D to detach
```

## File Structure

### Essential Files (Keep These)
- `ultroid.sh` - Master control script
- `ultroid_deploy.sh` - Deployment script
- `ultroid_status.sh` - Status checker
- `ultroid_stop.sh` - Stop script
- `.env` - Configuration file

### Instance Directories
- `instance1/` - First bot instance
- `instance2/` - Second bot instance

## Configuration

Edit `.env` file with your credentials:
```env
# Instance 1 (Main)
API_ID=your_api_id
API_HASH=your_api_hash
SESSION=your_session_1
MONGO_URI=your_mongo_uri
MONGODBNAME=FIRST

# Instance 2
API_ID1=your_api_id
API_HASH1=your_api_hash
SESSION1=your_session_2
MONGODBNAME1=SECOND
```

## Troubleshooting

### If instances won't start:
1. Check `.env` configuration
2. Verify session strings are valid
3. Ensure MongoDB is accessible
4. Check logs in `instance1/ultroid.log` and `instance2/ultroid.log`

### Clean restart:
```bash
./ultroid.sh stop
rm -rf instance1/*.session* instance2/*.session*
./ultroid.sh start
```
