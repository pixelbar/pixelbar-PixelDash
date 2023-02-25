import sys
import os
import signal
import logging
import logging.handlers
from pathlib import Path
import tomllib
from argparse import ArgumentParser, Namespace

try:
    from PySide2.QtGui import QGuiApplication
    from PySide2.QtQml import QQmlApplicationEngine, QQmlContext
    from PySide2.QtCore import Qt
except ImportError:
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine, QQmlContext
    from PySide6.QtCore import Qt


from src.pixel_dash import PixelDash
from src.config import Config


def parse_config(config_path: Path) -> Config:
    with open(config_path, 'rb') as file_handle:
        return Config(tomllib.load(file_handle))


def main(args: Namespace):
    config = parse_config(args.config)

    log_path = (Path(__file__).parent / Path(config.log_path)).absolute()
    pixeldash_ui_file = (
        Path(__file__).parent / Path("resources/qml/PixelDash.qml")
    ).absolute()

    if not log_path.parent.exists():
        log_path.parent.mkdir(parents=True, exist_ok=True)

    logging.basicConfig(
        format="%(asctime)s - %(levelname)s - %(message)s",
        level=logging.DEBUG if config.debug else logging.INFO,
        handlers=[
            logging.handlers.RotatingFileHandler(
                log_path,
                maxBytes=2000000,
                backupCount=10
            ),
            logging.StreamHandler(sys.stdout)
        ]
    )

    if config.debug:
        logging.info("Starting PixelDash in debug mode")
    else:
        logging.info("Starting PixelDash")

    # Unify default control looks across platforms
    os.environ["QT_QUICK_CONTROLS_STYLE"] = "Fusion"
    os.environ["QT_FONT_DPI"] = "96"

    # Create an instance of the application
    app = QGuiApplication(sys.argv)

    # Hide the cursor
    if not config.debug:
        app.setOverrideCursor(Qt.CursorShape.BlankCursor)

    pixel_dash = PixelDash(config)

    # Create QML engine
    engine = QQmlApplicationEngine()
    context = QQmlContext(engine.rootContext())

    engine.rootContext().setContextProperty("app", pixel_dash)
    engine.load(str(pixeldash_ui_file))

    # Catch CTRL+C and close the app when the window is closed
    signal.signal(signal.SIGINT, signal.SIG_DFL)
    engine.quit.connect(app.quit)

    result = app.exec_()
    pixel_dash.stop()
    sys.exit(result)


if __name__ == '__main__':
    # Setup argument parsing and pass results to main function
    parser = ArgumentParser()

    parser.add_argument(
        '-c',
        '--config',
        dest='config',
        default='config/pixeldash.toml',
        type=lambda p: Path(p).absolute(),
        help='Folder to config file. Defaults to config/pixeldash.toml'
    )

    args = parser.parse_args()

    main(args)
