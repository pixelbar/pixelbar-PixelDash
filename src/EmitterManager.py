import logging

from PySide2.QtCore import QObject, Property

from .emitters.LightsEmitter import LightsEmitter
from .emitters.GPIOEmitter import GPIOEmitter


class EmitterManager(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._emitters = {}

    def stop(self):
        for className in self._emitters:
            logging.info(f"Closing {className} emitter")
            self._emitters[className].stop()

    def getSensor(self, cls):
        className = cls.__name__
        if className not in self._emitters:
            logging.info(f"Creating {className} emitter")
            self._emitters[className] = cls()
            self._emitters[className].start()
        return self._emitters[className]

    def Lights(self) -> LightsEmitter:
        return self.getSensor(LightsEmitter)

    Lights = Property(QObject, fget=Lights, constant=True)

    def GPIO(self) -> GPIOEmitter:
        return self.getSensor(GPIOEmitter)

    GPIO = Property(QObject, fget=GPIO, constant=True)
