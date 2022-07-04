import requests

from .Sensor import Sensor

class RESTSensor(Sensor):
    def __init__(self) -> None:
        super().__init__()
        self._name = "Untitled REST sensor"

        self._url = ""
        self._timeout = 1

    def loopOnce(self) -> None:
        try:
            response = requests.get(self._url, timeout=self._timeout)
            self.processResponse(response)
        except requests.exceptions.Timeout:
            # timeout occured
            self._state = 400
            self._values = {}
        self.updateData()

    def processResponse(self, response: requests.Response) -> dict:
        try:
            json_data = response.json()
        except requests.exceptions.JSONDecodeError:
            json_data = {"content": response.text}

        self._state = response.status_code
        self._values = json_data
