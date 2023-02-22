import sys
import os
import signal
import logging
import logging.handlers
from pathlib import Path

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine, QQmlContext
from PySide2.QtCore import Qt

from src.pixel_dash import PixelDash

DEBUG = False
LOG_PATH = Path('logs/pixeldash.log').absolute()
PIXELDASH_UI_FILE = Path('resources/qml/PixelDash.qml').absolute()

if not LOG_PATH.parent.exists():
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)

logging.basicConfig(
    format="%(asctime)s - %(levelname)s - %(message)s",
    level=logging.DEBUG if DEBUG else logging.INFO,
    handlers=[
        logging.handlers.RotatingFileHandler(
            LOG_PATH,
            maxBytes=2000000,
            backupCount=10
        ),
        logging.StreamHandler(sys.stdout)
    ]
)

if DEBUG:
    logging.info("Starting PixelDash in debug mode")
else:
    logging.info("Starting PixelDash")

# Unify default control looks across platforms
os.environ["QT_QUICK_CONTROLS_STYLE"] = "Fusion"
os.environ["QT_FONT_DPI"] = "96"

# Create an instance of the application
app = QGuiApplication(sys.argv)

# Hide the cursor
if not DEBUG:
    app.setOverrideCursor(Qt.CursorShape.BlankCursor)

pixel_dash = PixelDash(debug=DEBUG)

# Create QML engine
engine = QQmlApplicationEngine()
context = QQmlContext(engine.rootContext())

engine.rootContext().setContextProperty("app", pixel_dash)
engine.load(str(PIXELDASH_UI_FILE))

# Catch CTRL+C and close the app when the window is closed
signal.signal(signal.SIGINT, signal.SIG_DFL)
engine.quit.connect(app.quit)

result = app.exec_()
pixel_dash.stop()
sys.exit(result)
