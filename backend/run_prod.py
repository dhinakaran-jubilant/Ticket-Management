import argparse
import os
from waitress import serve

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Run the production server.')
    parser.add_argument('-e', '--env', choices=['local', 'prod'], default='local', help='Environment (local or prod)')
    args = parser.parse_args()

    # Decide host and port based on environment (-e) value
    if args.env == 'prod':
        host = '192.168.0.7'
        port = 2501
    else:  # local
        host = 'localhost'
        port = 2501

    # Set environment variable BEFORE importing app to ensure database.py sees it
    os.environ['APP_ENV'] = args.env
    
    from app import app
    
    print(f"Starting Waitress server on {host}:{port} in {args.env} mode...")
    
    try:
        serve(app, host=host, port=port)
    except OSError as e:
        if host == '192.168.0.7':
            print(f"Warning: Failed to bind to {host}:{port} ({e}).")
            print("Falling back to binding on 0.0.0.0...")
            serve(app, host='0.0.0.0', port=port)
        else:
            raise
