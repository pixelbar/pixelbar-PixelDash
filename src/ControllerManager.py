from .controllers.LightsController import LightsController
from .controllers.GPIOController import GPIOController

from PySide2.QtCore import QObject, Property


class ControllerManager(QObject):
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

    def Lights(self) -> LightsController:
        return self.getSensor(LightsController)

    Lights = Property(QObject, fget=Lights, constant=True)

    def GPIO(self) -> GPIOController:
        return self.getSensor(GPIOController)

    GPIO = Property(QObject, fget=GPIO, constant=True)
