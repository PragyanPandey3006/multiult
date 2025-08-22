#!/usr/bin/env python3
"""
Multi-Instance Ultroid Startup Script
Created by @pragyan for deploying 5 Ultroid instances simultaneously
Starts 5 Ultroid instances from single .env configuration
"""

import os
import sys
import subprocess
import time
from pathlib import Path

def load_env_vars():
    """Load environment variables from .env file"""
    env_file = Path('.env')
    if not env_file.exists():
        print("❌ .env file not found! Please create it from .env.sample")
        return None
    
    env_vars = {}
    with open(env_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                env_vars[key.strip()] = value.strip()
    
    return env_vars

def create_instance_env(instance_num, env_vars, base_mongo_uri):
    """Create environment variables for a specific instance"""
    
    if instance_num == 0:
        # First instance uses base variables
        mongo_uri = env_vars.get('MONGO_URI', '')
        if not mongo_uri.endswith('/'):
            mongo_uri += '/'
        mongo_uri += 'ultroid_main'
        
        return {
            'API_ID': env_vars.get('API_ID', ''),
            'API_HASH': env_vars.get('API_HASH', ''),
            'SESSION': env_vars.get('SESSION', ''),
            'BOT_TOKEN': env_vars.get('BOT_TOKEN', ''),
            'LOG_CHANNEL': env_vars.get('LOG_CHANNEL', ''),
            'MONGO_URI': mongo_uri
        }
    else:
        # Other instances use numbered variables
        db_name = env_vars.get(f'MONGODBNAME{instance_num}', f'ultroid_instance_{instance_num+1}')
        
        if not base_mongo_uri.endswith('/'):
            base_mongo_uri += '/'
        mongo_uri = base_mongo_uri + db_name
        
        return {
            'API_ID': env_vars.get(f'API_ID{instance_num}', ''),
            'API_HASH': env_vars.get(f'API_HASH{instance_num}', ''),
            'SESSION': env_vars.get(f'SESSION{instance_num}', ''),
            'BOT_TOKEN': env_vars.get(f'BOT_TOKEN{instance_num}', ''),
            'LOG_CHANNEL': env_vars.get(f'LOG_CHANNEL{instance_num}', ''),
            'MONGO_URI': mongo_uri
        }

def start_instance(instance_num, instance_env):
    """Start a single Ultroid instance"""
    
    # Check if required variables are present
    required_vars = ['API_ID', 'API_HASH', 'SESSION']
    for var in required_vars:
        if not instance_env.get(var):
            print(f"⚠️  Skipping Instance {instance_num + 1}: Missing {var}")
            return False
    
    print(f"🚀 Starting Instance {instance_num + 1}...")
    
    # Create environment for subprocess
    proc_env = os.environ.copy()
    proc_env.update(instance_env)
    
    # Start instance in screen session
    screen_name = f"ultroid_instance_{instance_num + 1}"
    
    # Create the command to run inside screen
    activate_cmd = "source venv/bin/activate"
    run_cmd = "python3 -m pyUltroid"
    full_cmd = f"{activate_cmd} && {run_cmd}"
    
    cmd = ['screen', '-dmS', screen_name, 'bash', '-c', full_cmd]
    
    try:
        subprocess.run(cmd, env=proc_env, cwd=os.getcwd(), check=True)
        print(f"✅ Instance {instance_num + 1} started in screen '{screen_name}'")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to start Instance {instance_num + 1}: {e}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error starting Instance {instance_num + 1}: {e}")
        return False

def main():
    print("""
    ┏┳┓╋┏┓╋╋╋╋┏┓┏┓
    ┃┃┣┓┃┗┳┳┳━╋╋┛┃
    ┃┃┃┗┫┏┫┏┫╋┃┃╋┃
    ┗━┻━┻━┻┛┗━┻┻━┛

Multi-Instance Ultroid Deployment by @pragyan
Visit @TheUltroid for updates!!
""")
    
    # Load environment variables
    env_vars = load_env_vars()
    if not env_vars:
        return
    
    # Extract base MongoDB URI
    base_mongo_uri = env_vars.get('MONGO_URI', '')
    if not base_mongo_uri:
        print("❌ MONGO_URI not found in .env file!")
        return
    
    # Remove database name from URI if present (keep only the base URI)
    if '/' in base_mongo_uri.split('://')[-1]:
        parts = base_mongo_uri.split('/')
        if len(parts) > 3:  # mongodb://host:port/db or mongodb+srv://host/db
            base_mongo_uri = '/'.join(parts[:-1])
    
    print("🔧 Checking environment...")
    
    # Check if virtual environment exists
    if not Path('venv').exists():
        print("❌ Virtual environment not found!")
        print("Please run: virtualenv -p /usr/bin/python3 venv")
        print("Then: source venv/bin/activate && pip3 install -U -r requirements.txt")
        return
    
    # Check if screen is available
    try:
        subprocess.run(['screen', '--version'], check=True, capture_output=True)
        print("✅ Screen is available")
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ Screen not found! Installing...")
        try:
            subprocess.run(['sudo', 'apt-get', 'update'], check=True)
            subprocess.run(['sudo', 'apt-get', 'install', '-y', 'screen'], check=True)
            print("✅ Screen installed successfully")
        except subprocess.CalledProcessError:
            print("❌ Failed to install screen. Please install manually: sudo apt-get install screen")
            return
    
    print("🚀 Starting all instances...")
    
    started_instances = 0
    
    # Start all 5 instances
    for i in range(5):
        instance_env = create_instance_env(i, env_vars, base_mongo_uri)
        if start_instance(i, instance_env):
            started_instances += 1
        time.sleep(3)  # Delay between starts to avoid conflicts
    
    print(f"""
🎉 Multi-Instance deployment completed by @pragyan!
Started: {started_instances}/5 instances

Commands:
- View running instances: screen -ls
- Attach to instance: screen -r ultroid_instance_1
- Stop all instances: bash stop_all.sh
- Monitor instances: bash monitor.sh

Note: It may take a few moments for all instances to fully initialize.
""")

if __name__ == "__main__":
    main()
