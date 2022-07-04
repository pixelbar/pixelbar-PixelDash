import sys
import os
import signal

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine, QQmlContext
from PySide2.QtCore import Qt, QObject, Property

from SensorManager import SensorManager


class PixelDash(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._sensorManager = None

    def stop(self):
        if self._sensorManager:
            self._sensorManager.stop()

    def sensors(self) -> SensorManager:
        if not self._sensorManager:
            self._sensorManager = SensorManager()
        return self._sensorManager

    sensors = Property(QObject, fget=sensors, constant=True)

    def test(self) -> str:
        return "hello world!"

    test = Property(str, fget=test, constant=True)


if __name__ == "__main__":
    # Unify default control looks across platforms
    os.environ["QT_QUICK_CONTROLS_STYLE"] = "Fusion"

    # Create an instance of the application
    app = QGuiApplication(sys.argv)

    # Hide the cursor
    if False:
        app.setOverrideCursor(Qt.CursorShape.BlankCursor)

    pixelDash = PixelDash()

    # Create QML engine
    engine = QQmlApplicationEngine()
    context = QQmlContext(engine.rootContext())

    engine.rootContext().setContextProperty("app", pixelDash)
    engine.load(os.path.join("resources", "qml", "PixelDash.qml"))

    # Catch CTRL+C and close the app when the window is closed
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    engine.quit.connect(app.quit)

    result = app.exec_()
    pixelDash.stop()
    sys.exit(result)
