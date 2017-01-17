from blinkstick import blinkstick
from flask import Flask, jsonify, request
import threading
import psutil
import random

app = Flask(__name__)

is_looping = True

def change_led_color(colors):
    bsticks = blinkstick.find_all()
    if len(bsticks) > 0:
        print 'Changing colors to: ', colors[0:3]
        for bstick in bsticks:
            led_count = bstick.get_led_count()
            for x in range(0, led_count):
                bstick.set_color(channel=0, index=x, red=int(colors[0]), green=int(colors[1]), blue=int(colors[2]))
        return 'ok'
    else:
        print 'No blinkstick found'
        return 'No blinkstick found'


def change_led_random():
    bsticks = blinkstick.find_all()
    if len(bsticks) > 0:
        print 'Setting a random color to all leds'
        for bstick in bsticks:
            led_count = bstick.get_led_count()
            for x in range(0, led_count):
                bstick.set_color(channel=0, index=x, name="random")
        return 'ok'
    else:
        print 'No blinkstick found'
        return 'No blinkstick found'


def spaz_out():
    bsticks = blinkstick.find_all()
    if len(bsticks) > 0:
        print 'Setting a random color to all leds'
        while(is_looping):
            for bstick in bsticks:
                led_count = bstick.get_led_count()
                random_led = random.randint(0, led_count)
                bstick.set_color(channel=0, index=random_led, name="random")
        return 'ok'
    else:
        print 'No blinkstick found'
        return 'No blinkstick found'


def cpu_usage():
    print 'Returning cpu usage'
    return str(psutil.cpu_percent(interval=1))


def connections():
    p = psutil.Process()
    count = str(len(p.connections(kind='all')))
    return count


@app.route('/changecolor', methods=['POST'])

def change_color_all():
    global is_looping
    is_looping = False
    payload = request.get_json()
    return change_led_color(payload['rgb'])


@app.route('/randomcolor', methods=['POST'])
def random_color_all():
    global is_looping
    is_looping = False
    return change_led_random()


@app.route('/getcpuusage', methods=['POST'])
def get_cpu_usage():
    global is_looping
    is_looping = False
    return cpu_usage()


@app.route('/getconnections', methods=['POST'])
def get_connections():
    global is_looping
    is_looping = False
    return connections()


@app.route('/randomblink', methods=['POST'])
def spazing_out():
    global is_looping
    is_looping = True
    return spaz_out()


if __name__ == '__main__':
    app.run(host='0.0.0.0', threaded=True)
