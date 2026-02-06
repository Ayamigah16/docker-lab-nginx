import os
from flask import Flask

app = Flask(__name__)

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
    return {'status': 'healthy', 'environment': ENVIRONMENT}, 200

if __name__ == '__main__':
    app.run(host=APP_HOST, port=APP_PORT, debug=DEBUG_MODE)
