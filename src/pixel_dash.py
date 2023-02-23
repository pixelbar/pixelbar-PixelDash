try:
    from PySide2.QtCore import QObject, Property
except ImportError:
    from PySide6.QtCore import QObject, Property

from .sensor_manager import SensorManager
from .emitter_manager import EmitterManager


class PixelDash(QObject):
    def __init__(self, config):
        QObject.__init__(self)
        self._config = config
        self._debug = config.debug
        self._sensor_manager = None
        self._emitter_manager = None

    def stop(self):
        if self._sensor_manager:
            self._sensor_manager.stop()
        if self._emitter_manager:
            self._emitter_manager.stop()

    def debug(self) -> bool:
        return self._debug

    debug = Property(bool, fget=debug, constant=True)

    def sensors(self) -> SensorManager:
        if not self._sensor_manager:
            self._sensor_manager = SensorManager()
        return self._sensor_manager

    sensors = Property(QObject, fget=sensors, constant=True)

    def emitters(self) -> EmitterManager:
        if not self._emitter_manager:
            self._emitter_manager = EmitterManager()
        return self._emitter_manager

    emitters = Property(QObject, fget=emitters, constant=True)
