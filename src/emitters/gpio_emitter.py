import logging

try:
    import RPi.GPIO as GPIO
except ModuleNotFoundError:
    GPIO = None

from .emitter import Emitter


class GPIOEmitter(Emitter):
    def __init__(self, config) -> None:
        super().__init__()
        self._config = config
        self._pin_map = config["pin_map"]

        if not GPIO:
            return

        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)

        for pin in self._pin_map.values():
            GPIO.setup(pin, GPIO.OUT)
            GPIO.output(pin, GPIO.HIGH)

    def _processValues(self, values: dict):
        for key, value in values.items():
            try:
                GPIO.output(self._pin_map[key], GPIO.LOW if value else GPIO.HIGH)
            except KeyError:
                logging.error("Tried to set unknown pin name: %s", key)
            except AttributeError:
                # GPIO is not available
                pass
