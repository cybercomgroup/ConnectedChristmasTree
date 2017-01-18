from Bstick import Bstick
from flask import Flask, jsonify, request
import psutil

app = Flask(__name__)

bstick = Bstick.Stick(r_led_count=32)
if not bstick.connect():
    print "No blinkstick found"
    exit()


def cpu_usage():
    print 'Returning cpu usage'
    return str(psutil.cpu_percent(interval=1))


def connections():
    p = psutil.Process()
    count = str(len(p.connections(kind='all')))
    return count


@app.route('/changecolor', methods=['POST'])
def change_color_all():
    global spazing_out
    spazing_out = False
    payload = request.get_json()
    return bstick.change_led_color(payload['rgb'])


@app.route('/randomcolor', methods=['POST'])
def random_color_all():
    global spazing_out
    spazing_out = False
    return bstick.change_led_random()


@app.route('/getcpuusage', methods=['POST'])
def get_cpu_usage():
    global spazing_out
    spazing_out = False
    return cpu_usage()


@app.route('/getconnections', methods=['POST'])
def get_connections():
    global spazing_out
    spazing_out = False
    return connections()


@app.route('/randomblink', methods=['POST'])
def spazing_out():
    global spazing_out
    spazing_out = True
    return bstick.spaz_out()


if __name__ == '__main__':
    app.run(host='0.0.0.0', threaded=True)
