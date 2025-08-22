# Multi-Instance Ultroid Setup Guide

**Created by @pragyan**

This guide will help you deploy 5 Ultroid userbots simultaneously on the same VPS with separate configurations.

## 📋 Prerequisites

1. **VPS/Server** with Ubuntu/Debian
2. **Python 3.8+** installed
3. **5 different Telegram accounts** with session strings
4. **5 different bot tokens** from @BotFather
5. **MongoDB Atlas account** (free tier works)
6. **5 different log channels** (Telegram channels/groups)

## 🚀 Quick Setup

### Step 1: Environment Setup
```bash
# Clone the repository (if not done already)
git clone https://github.com/ufoptg/UltroidBackup.git
cd UltroidBackup

# Create virtual environment
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate

# Install dependencies
pip3 install -U -r requirements.txt
```

### Step 2: Configuration
Copy the example configuration:
```bash
cp .env.example .env
```

Edit `.env` file with your actual values:
```bash
nano .env
```

### Step 3: Fill Configuration
Fill the `.env` file with this format:

```env
# Instance 1 Configuration (Main)
API_ID=your_api_id
API_HASH=your_api_hash
SESSION=your_session_string_1
BOT_TOKEN=your_bot_token_1
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net
LOG_CHANNEL=-1001234567890

# Instance 2 Configuration  
API_ID1=your_api_id
API_HASH1=your_api_hash
SESSION1=your_session_string_2
BOT_TOKEN1=your_bot_token_2
MONGODBNAME1=FIRST
LOG_CHANNEL1=-1001234567891

# Instance 3 Configuration
API_ID2=your_api_id
API_HASH2=your_api_hash
SESSION2=your_session_string_3
BOT_TOKEN2=your_bot_token_3
MONGODBNAME2=SECOND
LOG_CHANNEL2=-1001234567892

# Instance 4 Configuration
API_ID3=your_api_id
API_HASH3=your_api_hash
SESSION3=your_session_string_4
BOT_TOKEN3=your_bot_token_4
MONGODBNAME3=THIRD
LOG_CHANNEL3=-1001234567893

# Instance 5 Configuration
API_ID4=your_api_id
API_HASH4=your_api_hash
SESSION4=your_session_string_5
BOT_TOKEN4=your_bot_token_5
MONGODBNAME4=FOURTH
LOG_CHANNEL4=-1001234567894
```

### Step 4: Deploy All Instances
```bash
bash startup
```

## 📊 Management Commands

### Monitor All Instances
```bash
bash monitor.sh
```

### Stop All Instances
```bash
bash stop_all.sh
```

### View Screen Sessions
```bash
screen -ls
```

### Attach to Specific Instance
```bash
screen -r ultroid_instance_1  # Replace 1 with desired instance number
```

### Detach from Screen Session
Press `Ctrl+A` then `D`

## 🗄️ Database Structure

Each instance will use a separate MongoDB database:
- Instance 1: `your_mongo_uri/ultroid_main`
- Instance 2: `your_mongo_uri/FIRST`
- Instance 3: `your_mongo_uri/SECOND`
- Instance 4: `your_mongo_uri/THIRD`
- Instance 5: `your_mongo_uri/FOURTH`

## 🔧 Troubleshooting

### Instance Not Starting
1. Check if all required variables are filled in `.env`
2. Verify session strings are valid
3. Check if bot tokens are correct
4. Ensure MongoDB URI is accessible

### Screen Session Issues
```bash
# Kill all screen sessions
screen -wipe

# Restart all instances
bash startup
```

### Check Instance Logs
```bash
# Attach to instance and view logs
screen -r ultroid_instance_1
```

### Memory Issues
If you face memory issues with 5 instances:
1. Increase VPS RAM
2. Add swap space:
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

## 📝 Important Notes

1. **Session Strings**: Each instance needs a unique session string from different Telegram accounts
2. **Bot Tokens**: Each instance needs a different bot token from @BotFather
3. **Log Channels**: Use different channels for each instance to avoid conflicts
4. **Database Names**: Each instance uses a separate database (automatically handled)
5. **Screen Sessions**: Each instance runs in its own screen session for isolation

## 🆘 Support

If you encounter issues:
1. Check the logs in screen sessions
2. Verify all configurations in `.env`
3. Ensure all dependencies are installed
4. Check MongoDB connectivity

## 🔄 Updates

To update all instances:
1. Stop all instances: `bash stop_all.sh`
2. Pull updates: `git pull`
3. Restart: `bash startup`

---

**Multi-Instance Deployment System Created by @pragyan 🚀**

For support and updates, contact @pragyan
