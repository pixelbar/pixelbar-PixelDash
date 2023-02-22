import logging
import requests

try:
    from simplejson.errors import JSONDecodeError
except ImportError:
    from json.decoder import JSONDecodeError

from .sensor import Sensor


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
                logging.warning("%s return HTTP response %s", self._url, response.status_code)
            self._processResponse(response)
        except requests.exceptions.Timeout:
            # timeout occurred
            logging.error("Timeout occurred while getting data from %s", self._url)
            self._state = 408
            self._values = {}
        except requests.exceptions.ConnectionError as e:
            # General connection error
            logging.error("Connection error occurred while getting data from %s", self._url)
            print(e)
            self._state = 500
            self._values = {}
        self._updateData()

    def _processResponse(self, response: requests.Response) -> dict:
        try:
            json_data = response.json()
        except JSONDecodeError:
            json_data = {"content": response.text}

        self._state = response.status_code
        self._values = json_data
