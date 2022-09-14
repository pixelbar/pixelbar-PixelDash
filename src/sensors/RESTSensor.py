import requests
import logging

from .Sensor import Sensor


class RESTSensor(Sensor):
    def __init__(self) -> None:
        super().__init__()
        self._name = "Untitled REST sensor"

        self._url = ""
        self._timeout = 2

    def loopOnce(self) -> None:
        try:
            response = requests.get(self._url, timeout=self._timeout)
            if response.status_code != 200:
                logging.warning(f"{self._url} return HTTP response {response.status_code}")
            self._processResponse(response)
        except requests.exceptions.Timeout:
            # timeout occured
            logging.error(f"Timeout occured while getting data from {self._url}")
            self._state = 408
            self._values = {}
        self._updateData()

    def _processResponse(self, response: requests.Response) -> dict:
        try:
            json_data = response.json()
        except requests.exceptions.JSONDecodeError:
            json_data = {"content": response.text}

        self._state = response.status_code
        self._values = json_data
