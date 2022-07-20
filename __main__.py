import sys
import os
import signal
import logging

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine, QQmlContext
from PySide2.QtCore import Qt

from src.PixelDash import PixelDash

DEBUG = True

logging.basicConfig(
    format="%(asctime)s - %(levelname)s - %(message)s", level=logging.DEBUG if DEBUG else logging.INFO
)
if DEBUG:
    logging.info("Starting PixelDash in debug mode")
else:
    logging.info("Starting PixelDash")

# Unify default control looks across platforms
os.environ["QT_QUICK_CONTROLS_STYLE"] = "Fusion"

# Create an instance of the application
app = QGuiApplication(sys.argv)

# Hide the cursor
if not DEBUG:
    app.setOverrideCursor(Qt.CursorShape.BlankCursor)

pixelDash = PixelDash(debug = DEBUG)

# Create QML engine
engine = QQmlApplicationEngine()
context = QQmlContext(engine.rootContext())

engine.rootContext().setContextProperty("app", pixelDash)
engine.load(os.path.join(os.path.dirname(__file__), "resources", "qml", "PixelDash.qml"))

# Catch CTRL+C and close the app when the window is closed
signal.signal(signal.SIGINT, signal.SIG_DFL)
engine.quit.connect(app.quit)

result = app.exec_()
pixelDash.stop()
sys.exit(result)
