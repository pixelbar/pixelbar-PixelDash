from PySide2.QtCore import QObject, Property

from .SensorManager import SensorManager
from .ControllerManager import ControllerManager

class PixelDash(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._sensorManager = None
        self._controllerManager = None

    def stop(self):
        if self._sensorManager:
            self._sensorManager.stop()
        if self._controllerManager:
            self._controllerManager.stop()

    def sensors(self) -> SensorManager:
        if not self._sensorManager:
            self._sensorManager = SensorManager()
        return self._sensorManager

    sensors = Property(QObject, fget=sensors, constant=True)

    def controllers(self) -> ControllerManager:
        if not self._controllerManager:
            self._controllerManager = ControllerManager()
        return self._controllerManager

    controllers = Property(QObject, fget=controllers, constant=True)
