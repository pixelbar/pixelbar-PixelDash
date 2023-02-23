import logging

try:
    from PySide2.QtCore import QObject, Property
except ImportError:
    from PySide6.QtCore import QObject, Property

from .sensors.spacestate_sensor import SpaceStateSensor
from .sensors.weather_sensor import WeatherSensor
from .sensors.ikea_sensor import IKEASensor
from .sensors.tasmota2_sensor import Tasmota2Sensor
from .sensors.jim_sensor import JimSensor
from .sensors.pim_sensor import PimSensor
from .sensors.rpi_telemetry_sensor import RPITelemetrySensor


class SensorManager(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._sensors = {}

    def stop(self):
        for name, sensor_class in self._sensors.items():
            logging.info("Closing %s sensor", name)
            sensor_class.stop()

    def getSensor(self, cls):
        name = cls.__name__
        if name not in self._sensors:
            logging.info("Creating %s sensor", name)
            self._sensors[name] = cls()
            self._sensors[name].start()
        return self._sensors[name]

    def SpaceState(self) -> SpaceStateSensor:
        return self.getSensor(SpaceStateSensor)

    SpaceState = Property(QObject, fget=SpaceState, constant=True)

    def Weather(self) -> WeatherSensor:
        return self.getSensor(WeatherSensor)

    Weather = Property(QObject, fget=Weather, constant=True)

    def IKEA(self) -> IKEASensor:
        return self.getSensor(IKEASensor)

    IKEA = Property(QObject, fget=IKEA, constant=True)

    def Tasmota2(self) -> Tasmota2Sensor:
        return self.getSensor(Tasmota2Sensor)

    Tasmota2 = Property(QObject, fget=Tasmota2, constant=True)

    def Jim(self) -> JimSensor:
        return self.getSensor(JimSensor)

    Jim = Property(QObject, fget=Jim, constant=True)

    def Pim(self) -> PimSensor:
        return self.getSensor(PimSensor)

    Pim = Property(QObject, fget=Pim, constant=True)

    def RPI(self) -> RPITelemetrySensor:
        return self.getSensor(RPITelemetrySensor)

    RPI = Property(QObject, fget=RPI, constant=True)
