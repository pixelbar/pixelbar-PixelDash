from PySide2.QtCore import QObject, Property

from .SensorManager import SensorManager


class PixelDash(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._sensorManager = None

    def stop(self):
        if self._sensorManager:
            self._sensorManager.stop()

    def sensors(self) -> SensorManager:
        if not self._sensorManager:
            self._sensorManager = SensorManager()
        return self._sensorManager

    sensors = Property(QObject, fget=sensors, constant=True)
