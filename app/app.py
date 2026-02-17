import os
import time
from datetime import datetime
from flask import Flask

app = Flask(__name__)

# Track application start time for uptime calculation
APP_START_TIME = time.time()

# Application version
APP_VERSION = os.getenv('APP_VERSION', '1.0.0')

# Externalized configuration via environment variables
APP_HOST = os.getenv('APP_HOST', '0.0.0.0')
APP_PORT = int(os.getenv('APP_PORT', '5000'))
ENVIRONMENT = os.getenv('ENVIRONMENT', 'production')
DEBUG_MODE = os.getenv('DEBUG', 'false').lower() == 'true'

@app.route('/')
def home():
    return f'Hello from Docker! Running in {ENVIRONMENT} mode.'

@app.route('/health')
def health():
    """
    Enhanced health endpoint with comprehensive status information.
    Returns: JSON object with status, environment, version, uptime, and timestamp
    """
    current_time = time.time()
    uptime_seconds = int(current_time - APP_START_TIME)
    
    return {
        'status': 'healthy',
        'environment': ENVIRONMENT,
        'version': APP_VERSION,
        'uptime_seconds': uptime_seconds,
        'timestamp': datetime.utcnow().isoformat() + 'Z'
    }, 200

if __name__ == '__main__':
    app.run(host=APP_HOST, port=APP_PORT, debug=DEBUG_MODE)
