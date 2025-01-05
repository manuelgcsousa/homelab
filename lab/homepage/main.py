# /// script
# dependencies = [
#   "Flask==3.1.*",
#   "psutil==6.1.*"
# ]
# ///

import logging
import psutil

from flask import (
    Flask,
    jsonify,
    render_template
)


app = Flask(__name__)

logging.disable(logging.CRITICAL)


@app.route('/')
def index():
    hostname = '192.168.27.69'
    services = {
        'File Browser': f"http://{hostname}:8080",
        'Transmission': f"http://{hostname}:9091",
        'Localboard': f"http://{hostname}:27049",
        'Plex': f"http://{hostname}:32400/web",
        'Overseerr': f"http://{hostname}:5055",
        'Radarr': f"http://{hostname}:7878",
        'Sonarr': f"http://{hostname}:8989",
        'Bazarr': f"http://{hostname}:6767",
        'Prowlarr': f"http://{hostname}:9696",
    }
    return render_template('index.html', services=services)


@app.route('/stats')
def stats():
    def get_cpu_usage():
        return f"{psutil.cpu_percent(interval=1)} %"

    def get_memory_usage():
        used = round(psutil.virtual_memory().used / (1024 ** 3), 2)
        total = round(psutil.virtual_memory().total / (1024 ** 3), 2)
        return f"{used} GB / {total} GB"

    def get_disk_usage(mount_point):
        used = round(psutil.disk_usage(mount_point).used / (1024 ** 3), 2)
        total = round(psutil.disk_usage(mount_point).total / (1024 ** 3), 2)
        return f"{used} GB / {total} GB"

    def get_cpu_temperature():
        try:
            with open('/sys/class/thermal/thermal_zone0/temp', 'r') as f:
                temperature = f.read()
            return f"{round(int(temperature) / 1000.0, 1)} °C"
        except Exception:
            return "N/A"
        
    return jsonify({
        'cpu': get_cpu_usage(),
        'memory': get_memory_usage(),
        'internal_disk': get_disk_usage('/'),
        'external_disk': get_disk_usage('/mnt/ssd1'),
        'temperature': get_cpu_temperature()
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)
