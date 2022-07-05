from sensors.SpaceStateSensor import SpaceStateSensor
from sensors.WeatherSensor import WeatherSensor
from sensors.IKEASensor import IKEASensor
from sensors.JimSensor import JimSensor
from sensors.PimSensor import PimSensor
from sensors.RPITelemetrySensor import RPITelemetrySensor

from PySide2.QtCore import QObject, Property


class SensorManager(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._sensors = {}

    def stop(self):
        for className in self._sensors:
            self._sensors[className].stop()

    def getSensor(self, cls):
        className = cls.__name__
        if className not in self._sensors:
            self._sensors[className] = cls()
            self._sensors[className].start()
        return self._sensors[className]

    def SpaceState(self) -> SpaceStateSensor:
        return self.getSensor(SpaceStateSensor)

    SpaceState = Property(QObject, fget=SpaceState, constant=True)

    def Weather(self) -> WeatherSensor:
        return self.getSensor(WeatherSensor)

    Weather = Property(QObject, fget=Weather, constant=True)

    def IKEA(self) -> IKEASensor:
        return self.getSensor(IKEASensor)

    IKEA = Property(QObject, fget=IKEA, constant=True)

    def Jim(self) -> JimSensor:
        return self.getSensor(JimSensor)

    Jim = Property(QObject, fget=Jim, constant=True)

    def Pim(self) -> PimSensor:
        return self.getSensor(PimSensor)

    Pim = Property(QObject, fget=Pim, constant=True)

    def RPI(self) -> RPITelemetrySensor:
        return self.getSensor(RPITelemetrySensor)

    RPI = Property(QObject, fget=RPI, constant=True)
