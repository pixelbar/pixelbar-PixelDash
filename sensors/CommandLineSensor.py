import subprocess

from .Sensor import Sensor

class CommandLineSensor(Sensor):
    def __init__(self) -> None:
        super().__init__()

        self._name = "Untitled command line sensor"
        self._command = ""

    def loopOnce(self) -> None:
        response = subprocess.Popen(self._command,  shell=True, stdin=None, stdout=subprocess.PIPE, stderr=subprocess.PIPE, close_fds=True)
        self.processResponse(response)
        self.updateData()

    def processResponse(self, response: subprocess.Popen) -> dict:
        self._state = response.status_code
        #print(response.stderr.read())
        #print(response.stdout.read())
