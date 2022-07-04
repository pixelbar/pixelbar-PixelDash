from sensors.SpaceStateSensor import SpaceStateSensor
from sensors.WeatherSensor import WeatherSensor
from sensors.IKEASensor import IKEASensor
from sensors.JimSensor import JimSensor
from sensors.PimSensor import PimSensor
from sensors.RPITelemetrySensor import RPITelemetrySensor

from PyQt6.QtCore import QObject, pyqtProperty

class SensorManager(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._spaceStateSensor = None
        self._weatherSensor = None
        self._ikeaSensor = None
        self._jimSensor = None
        self._pimSensor = None
        self._rpiSensor = None

    def stop(self):
        if self._spaceStateSensor:
            self._spaceStateSensor.stop()
        if self._weatherSensor:
            self._weatherSensor.stop()
        if self._ikeaSensor:
            self._ikeaSensor.stop()

    @pyqtProperty(QObject, constant=True)
    def SpaceState(self) -> SpaceStateSensor:
        if not self._spaceStateSensor:
            self._spaceStateSensor = SpaceStateSensor()
            self._spaceStateSensor.start()
        return self._spaceStateSensor

    @pyqtProperty(QObject, constant=True)
    def Weather(self) -> WeatherSensor:
        if not self._weatherSensor:
            self._weatherSensor = WeatherSensor()
            self._weatherSensor.start()
        return self._weatherSensor

    @pyqtProperty(QObject, constant=True)
    def IKEA(self) -> IKEASensor:
        if not self._ikeaSensor:
            self._ikeaSensor = IKEASensor()
            self._ikeaSensor.start()
        return self._ikeaSensor

    @pyqtProperty(QObject, constant=True)
    def Jim(self) -> JimSensor:
        if not self._jimSensor:
            self._jimSensor = JimSensor()
            self._jimSensor.start()
        return self._jimSensor

    @pyqtProperty(QObject, constant=True)
    def Pim(self) -> PimSensor:
        if not self._pimSensor:
            self._pimSensor = PimSensor()
            self._pimSensor.start()
        return self._pimSensor

    @pyqtProperty(QObject, constant=True)
    def RPI(self) -> RPITelemetrySensor:
        if not self._rpiSensor:
            self._rpiSensor = RPITelemetrySensor()
            self._rpiSensor.start()
        return self._rpiSensor
