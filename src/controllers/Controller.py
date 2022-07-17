from PySide2.QtCore import QObject, Slot


class Controller(QObject):
    def __init__(self) -> None:
        super().__init__()
        self._running = False

    def __del__(self):
        if self._running:
            self.stop()

    def start(self) -> None:
        self._running = True

    def stop(self) -> None:
        self._running = False

    @Slot("QVariantMap")
    def emit(self, values: dict) -> None:
        self._processValues(values)

    def _processValues(self, values: dict) -> None:
        pass