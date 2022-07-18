import threading
import time

from PySide2.QtCore import QObject, Signal, Property, Slot


class Emitter(QObject):
    def __init__(self) -> None:
        super().__init__()
        self._interval = 0

        self._thread = threading.Thread()

        self._values = {}
        self._values_dirty = False

        self._state = 0
        self._timestamp = 0.0

    def __del__(self):
        self.stop()

    def start(self) -> None:
        pass

    def stop(self) -> None:
        pass

    @Slot("QVariantMap")
    def push(self, values: dict) -> None:
        self._values = values
        self._values_dirty = True

        if not self._thread.is_alive():
            self._thread = threading.Thread(target=self._threadFunction, daemon=True)
            self._thread.start()

    def _threadFunction(self) -> None:
        while self._values_dirty:
            start_time = time.monotonic()
            self._processValues(self._values)
            self._values_dirty = False
            self._timestamp = time.monotonic()
            self.dataPushed.emit()

            time_left = self._interval - (time.monotonic() - start_time)
            if time_left > 0:
                time.sleep(time_left)

    def _processValues(self, values: dict) -> None:
        pass

    dataPushed = Signal()

    def state(self) -> int:
        return self._state

    state = Property(int, fget=state, notify=dataPushed)

    def timestamp(self) -> float:
        return self._timestamp

    timestamp = Property(float, fget=timestamp, notify=dataPushed)

    intervalChanged = Signal()

    def interval(self) -> float:
        return self._interval

    def setInterval(self, interval: float) -> None:
        self._interval = interval

    interval = Property(float, fget=interval, fset=setInterval, notify=intervalChanged)
