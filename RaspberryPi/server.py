from blinkstick import blinkstick
from flask import Flask, jsonify, request
import psutil
import random
import time

app = Flask(__name__)

spazing_out = True

class Main(blinkstick.BlinkStickPro):
    def change_led_color(self, colors):
        self.clear()
        print 'Changing colors to: ', colors[0:3]
        for x in range(0, self.r_led_count):
            self.set_color_or(x, int(colors[0]), int(colors[1]), int(colors[2]))
        self.send_data_all()
        time.sleep(0.1)
        return 'ok'

    def change_led_random(self):
        self.clear()
        print 'Setting a random color to all leds'
        for x in range(0, self.r_led_count):
            rr = random.randint(0, 255)
            rg = random.randint(0, 255)
            rb = random.randint(0, 255)
            self.set_color_or(x, rr, rb, rg)

        self.send_data_all()
        time.sleep(0.1)
        return 'ok'

    def spaz_out(self): # Needs a bit of update
        print 'Setting a random color to all leds on random index'
        while spazing_out:
            rr = random.randint(0, 255)
            rg = random.randint(0, 255)
            rb = random.randint(0, 255)
            random_led = random.randint(0, self.r_led_count)

            self.set_color_or(random_led, rr, rb, rg)
            self.send_data_all()
            time.sleep(0.1)
        return 'ok'

    def set_color_or(self, x, r, g, b):
        cr, cg, cb = self.get_color(0, x)
        self.set_color(0, x, int(r) | int(cr), int(g) | int(cg), int(b) | int(cb))

bstick = Main(r_led_count=32)
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

