from blinkstick import blinkstick
import random
import time


class Stick(blinkstick.BlinkStickPro):

    def change_led_color(self, colors):
        self.clear()
        print 'Changing colors to: ', colors[0:3]
        for x in range(0, self.r_led_count):
            self.set_color(0, x, int(colors[0]), int(colors[1]), int(colors[2]))
        self.send_data_all()
        time.sleep(0.020)
        return 'ok'


    def change_color_name(self, color):
        self.clear()
        print 'Changing color to: ', color
        # Need to find a parser for color name
        red, green, blue = self.bstick._name_to_rgb(color)
        for x in range(0, self.r_led_count):
            self.set_color(0, x, red, green, blue)
        self.send_data_all()
        time.sleep(0.020)
        return 'ok'

    def change_color_hex(self, hex):
        self.clear()
        print 'Changing colors to: ', hex
        red, green, blue = self.bstick._hex_to_rgb(hex.upper())
        for x in range(0, self.r_led_count):
            self.set_color(0, x, red, green, blue)
        self.send_data_all()
        time.sleep(0.020)
        return 'ok'


    def change_led_random(self):
        self.clear()
        print 'Setting a random color to all leds'
        for x in range(0, self.r_led_count):
            rr = random.randint(0, 255)
            rg = random.randint(0, 255)
            rb = random.randint(0, 255)
            self.set_color(0, x, rr, rb, rg)

        self.send_data_all()
        time.sleep(0.020)
        return 'ok'

