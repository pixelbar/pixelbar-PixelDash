import threading
import time

try:
    from PySide2.QtCore import QObject, Signal, Property
except ImportError:
    from PySide6.QtCore import QObject, Signal, Property


class Sensor(QObject):
    def __init__(self) -> None:
        super().__init__()
        self._name = "Untitled sensor"
        self._interval = 10

        self._thread = threading.Thread(target=self.loopForEver, daemon=True)

        self._state = 0
        self._timestamp = 0.0
        self._values = {}
        self._unit_map = {}

    def __del__(self):
        pass

    def start(self) -> None:
        self._thread.start()

    def stop(self) -> None:
        pass

    def loopForEver(self) -> None:
        while True:
            start_time = time.monotonic()
            self.loopOnce()
            time_left = self._interval - (time.monotonic() - start_time)
            if time_left > 0:
                time.sleep(time_left)

    def loopOnce(self) -> None:
        self._updateData()

    def _processResponse(self) -> None:
        pass

    def _updateData(self) -> None:
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
        return self._unit_map

    unitMap = Property("QVariantMap", fget=unitMap, constant=True)
