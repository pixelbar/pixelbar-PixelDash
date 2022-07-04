from .CommandLineSensor import CommandLineSensor

import psutil
import re
import subprocess

class RPITelemetrySensor(CommandLineSensor):
    def __init__(self):
        super().__init__()
        self._name = "Raspberry Pi"
        self._period = 10
        self._command = "vcgencmd measure_temp"

        self._re = re.compile(r"celciusTemp: ([\d\.]*)")

        """
        Ëxample text/plain response:

        temp=42.8'C

        """


    def processResponse(self, response: subprocess.Popen) -> dict:
        values = {
            "CPU usage": psutil.cpu_percent(interval=0.25),
            "Memory usage": psutil.virtual_memory().percent
        }

        result = self._re.search(response.stdout.read())
        if result:
            values["Temperature"] =  float(matches[0])
        else:
            values["Temperature"] = None

        self._state = response.status_code
        self._values = values
