from blinkstick import blinkstick
from flask import Flask, jsonify, request

app = Flask(__name__)

def change_led_color(colors):
        if blinkstick.find_all() > 0:
                print 'Changing colors to: ', colors[0:3]   
                for ledstrip in blinkstick.find_all():
                        for x in range(0, 32):
                                ledstrip.set_color(0, x ,int(colors[0]),int(colors[1]),int(colors[2]))
                return 'ok'

@app.route('/changecolor', methods=['POST'])
def change_color_all():
        payload = request.get_json()
        change_led_color(payload['rgb'])
        return ''

if __name__ == '__main__':
                app.run(host='0.0.0.0')