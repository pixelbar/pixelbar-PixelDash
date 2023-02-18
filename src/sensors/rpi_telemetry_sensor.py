import psutil
import re
import subprocess

from .command_line_sensor import CommandLineSensor

class RPITelemetrySensor(CommandLineSensor):
    def __init__(self):
        super().__init__()
        self._name = "Raspberry Pi"
        self._interval = 10
        self._command = "vcgencmd measure_temp"

        self._re = re.compile(r"temp=([\d\.]*)")

        self._unit_map = {
            "CPU usage": "%",
            "Memory usage": "%",
            "Temperature": "°C"
        }

        """
        Example text/plain response:

        temp=42.8'C

        """

    def _processResponse(self, response: subprocess.Popen) -> dict:
        values = {
            "CPU usage": psutil.cpu_percent(interval=0.25),
            "Memory usage": psutil.virtual_memory().percent,
        }

        matches = self._re.search(response.stdout.read().decode())
        if matches:
            values["Temperature"] = float(matches[1])
            self._state = 200
        else:
            values["Temperature"] = None
            self._state = 404

        self._values = values
