from blinkstick import blinkstick
from flask import Flask, jsonify, request

app = Flask(__name__)


def change_led_color(colors):
    bsticks = blinkstick.find_all()
    if len(bsticks) > 0:
        print 'Changing colors to: ', colors[0:3]
        for ledstrip in bsticks:
            for x in range(0, 32):
                ledstrip.set_color(channel=0, index=x, red=int(colors[0]), green=int(colors[1]), blue=int(colors[2]))
        return 'ok'
    else:
        print 'No blinkstick found'
        return 'No blinkstick found'


def change_led_random():
    bsticks = blinkstick.find_all()
    if len(bsticks) > 0:
        print 'Setting a random color to all leds'
        for bstick in bsticks:
            for x in range(0, 32):
                bstick.set_color(channel=0, index=x, name="random")
        return 'ok'
    else:
        print 'No blinkstick found'
        return 'No blinkstick found'


@app.route('/changecolor', methods=['POST'])
def change_color_all():
    payload = request.get_json()
    return change_led_color(payload['rgb'])


@app.route('/randomcolor', methods=['GET'])
def random_color_all():
    return change_led_random()


if __name__ == '__main__':
    app.run(host='0.0.0.0')
