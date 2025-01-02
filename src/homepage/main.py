# /// script
# dependencies = [
#   "Flask==3.1.*",
#   "psutil==6.1.*"
# ]
# ///

import logging
import psutil

from flask import Flask, jsonify, send_from_directory


app = Flask(__name__)

logging.disable(logging.CRITICAL)


@app.route('/')
def index():
    return send_from_directory('static', 'index.html')


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
