try:
    import RPi.GPIO as GPIO
except ModuleNotFoundError:
    GPIO = None

from .Controller import Controller


class GPIOController(Controller):
    def __init__(self) -> None:
        super().__init__()

        self._pin_map = {
            "loadingdoor": 22,
            "pixeldoor": 23,
            "docklight": 24,
            "unused": 25,
        }

        if not GPIO:
            return

        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)

        for pin in self._pin_map.values():
            GPIO.setup(pin, GPIO.OUT)
            GPIO.output(pin, GPIO.HIGH)

    def processValues(self, values: dict):
        for key, value in values.items():
            try:
                GPIO.output(self._pin_map[key], GPIO.LOW if value else GPIO.HIGH)
            except KeyError:
                print(f"Tried to set unknown pin name: {key}")
            except AttributeError:
                # GPIO is not avaialble
                pass
