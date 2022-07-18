from PySide2.QtCore import QObject, Property

from .SensorManager import SensorManager
from .EmitterManager import EmitterManager

class PixelDash(QObject):
    def __init__(self, debug):
        QObject.__init__(self)
        self._debug = debug
        self._sensorManager = None
        self._emitterManager = None

    def stop(self):
        if self._sensorManager:
            self._sensorManager.stop()
        if self._emitterManager:
            self._emitterManager.stop()

    def debug(self) -> bool:
        return self._debug

    debug = Property(bool, fget=debug, constant=True)

    def sensors(self) -> SensorManager:
        if not self._sensorManager:
            self._sensorManager = SensorManager()
        return self._sensorManager

    sensors = Property(QObject, fget=sensors, constant=True)

    def emitters(self) -> EmitterManager:
        if not self._emitterManager:
            self._emitterManager = EmitterManager()
        return self._emitterManager

    emitters = Property(QObject, fget=emitters, constant=True)
