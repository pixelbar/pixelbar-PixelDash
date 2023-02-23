import logging

try:
    from PySide2.QtCore import QObject, Property
except ImportError:
    from PySide6.QtCore import QObject, Property

from .emitters.lights_emitter import LightsEmitter
from .emitters.gpio_emitter import GPIOEmitter
from .emitters.vcgencmd_emitter import VCGenCmdEmitter


class EmitterManager(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._emitters = {}

    def stop(self):
        for name, emitter_class in self._emitters.items():
            logging.info("Closing %s emitter", name)
            emitter_class.stop()

    def getSensor(self, cls):
        class_name = cls.__name__
        if class_name not in self._emitters:
            logging.info("Creating %s emitter", class_name)
            self._emitters[class_name] = cls()
            self._emitters[class_name].start()
        return self._emitters[class_name]

    def Lights(self) -> LightsEmitter:
        return self.getSensor(LightsEmitter)

    Lights = Property(QObject, fget=Lights, constant=True)

    def GPIO(self) -> GPIOEmitter:
        return self.getSensor(GPIOEmitter)

    GPIO = Property(QObject, fget=GPIO, constant=True)

    def VCGenCmd(self) -> VCGenCmdEmitter:
        return self.getSensor(VCGenCmdEmitter)

    VCGenCmd = Property(QObject, fget=VCGenCmd, constant=True)
