import threading
import time

from PySide2.QtCore import QObject, Signal, Property


class Sensor(QObject):
    def __init__(self) -> None:
        super().__init__()
        self._name = "Untitled sensor"
        self._interval = 10

        self._running = False
        self._thread = threading.Thread(target=self.loopForEver)

        self._state = 0
        self._timestamp = 0.0
        self._values = {}
        self._unitMap = {}

    def __del__(self):
        if self._running:
            self.stop()

    def start(self) -> None:
        self._thread.start()

    def stop(self) -> None:
        self._running = False
        self._thread.join()

    def loopForEver(self) -> None:
        self._running = True
        while self._running:
            start_time = time.monotonic()
            self.loopOnce()
            while self._running and time.monotonic() - start_time < self._interval:
                time.sleep(0.5)

    def loopOnce(self) -> None:
        self.updateData()

    def processResponse(self) -> None:
        pass

    def updateData(self) -> None:
        self._timestamp = time.monotonic()
        self.dataChanged.emit()

    dataChanged = Signal()

    def state(self) -> int:
        return self._state

    state = Property(int, fget=state, notify=dataChanged)

    def timestamp(self) -> float:
        return self._timestamp

    timestamp = Property(float, fget=timestamp, notify=dataChanged)

    def values(self) -> dict:
        return self._values

    values = Property("QVariantMap", fget=values, notify=dataChanged)

    def name(self) -> str:
        return self._name

    name = Property(str, fget=name, constant=True)

    intervalChanged = Signal()

    def interval(self) -> float:
        return self._interval

    def setInterval(self, interval: float) -> None:
        self._interval = interval

    interval = Property(float, fget=interval, fset=setInterval, notify=intervalChanged)

    def unitMap(self) -> dict:
        return self._unitMap

    unitMap = Property("QVariantMap", fget=unitMap, constant=True)
