from PySide2.QtCore import QObject, Slot


class Controller(QObject):
    def __init__(self) -> None:
        super().__init__()

    def __del__(self):
        if self._running:
            self.stop()

    def start(self) -> None:
        pass

    def stop(self) -> None:
        pass

    @Slot("QVariantMap")
    def emit(self, values: dict) -> None:
        self._processValues(values)

    def _processValues(self, values: dict) -> None:
        pass