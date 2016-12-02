from blinkstick import blinkstick
from flask import Flask, jsonify, request
import random
import time

app = Flask(__name__)

intrutped = False

def change_led_color(colors):
        if blinkstick.find_all() > 0:
                print 'Changing colors to: ', colors[0:3]   
                for ledstrip in blinkstick.find_all():
                        for x in range(0, 32):
                                ledstrip.set_color(0, x ,int(colors[0]),int(colors[1]),int(colors[2]))

def spaz_out():
        if blinkstick.find_all() > 0:
                while (intrutped == False):
                        for ledstrip in blinkstick.find_all():
                                ledstrip.set_color(0, random.randint(0,32),random.randint(0,255),random.randint(0,255),random.randint(0,255))
                                time.sleep(2)

def idle():
        if blinkstick.find_all() > 0:
                print 'LEDs going into idle'   
                for ledstrip in blinkstick.find_all():
                        for x in range(0, 32):
                                ledstrip.set_color(0, x ,int(0),int(0),int(0))

@app.route('/changecolor', methods=['POST'])
def change_color_all():
        global interupted
        interupted = True
        payload = request.get_json()
        change_led_color(payload['rgb'])
        return 'ok'

@app.route('/randomcolor', methods=['POST'])
def change_color_random():
        global interupted
        interupted = False
        spaz_out()
        return 'ok'

@app.route('/turnoff', methods=['POST'])
def turn_off():
        idle()
        return 'ok'
        
if __name__ == '__main__':
                app.run(host='0.0.0.0')