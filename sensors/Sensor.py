import threading
import time

from PyQt6.QtCore import QObject, pyqtSignal, pyqtProperty

class Sensor(QObject):
    def __init__(self) -> None:
        super().__init__()
        self._name = "Untitled sensor"
        self._period = 10

        self._running = False
        self._thread = threading.Thread(target=self.loopForEver)

        self._state = 0
        self._timestamp = 0.0
        self._values = {}

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
            while self._running and time.monotonic() - start_time < self._period:
                time.sleep(0.5)

    def loopOnce(self) -> None:
        self.updateData()

    def processResponse(self) -> None:
        pass

    def updateData(self) -> None:
        self._timestamp = time.monotonic()
        self.dataChanged.emit()

    dataChanged = pyqtSignal()
    @pyqtProperty(int, notify=dataChanged)
    def state(self) -> int:
        return self._state

    @pyqtProperty(float, notify=dataChanged)
    def timestamp(self) -> float:
        return self._timestamp

    @pyqtProperty("QVariantMap", notify=dataChanged)
    def values(self) -> dict:
        return self._values

    @pyqtProperty(str, constant=True)
    def name(self) -> str:
        return self._name
