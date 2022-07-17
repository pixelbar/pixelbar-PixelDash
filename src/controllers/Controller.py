from PySide2.QtCore import QObject, Slot, QTimer


class Controller(QObject):
    def __init__(self) -> None:
        super().__init__()
        self._throttle_interval = 0

        self._timer = QTimer()
        self._timer.setSingleShot(True)
        self._timer.timeout.connect(self._throttleStep)

        self._values = {}
        self._values_dirty = False

    def __del__(self):
        self.stop()

    def start(self) -> None:
        pass

    def stop(self) -> None:
        pass

    @Slot("QVariantMap")
    def emit(self, values: dict) -> None:
        if self._throttle_interval == 0:
            self._processValues(values)
            return

        if not self._timer.isActive():
            self._timer.start(self._throttle_interval)
            self._values_dirty = False
            self._processValues(values)
        else:
            self._values_dirty = True
            self._values = values

    def _throttleStep(self) -> None:
        if self._values_dirty:
            self._timer.start(self._throttle_interval)
            self._values_dirty = False
            self._processValues(self._values)

    def _processValues(self, values: dict) -> None:
        pass