from .RESTSensor import RESTSensor

import requests
import re


class JimSensor(RESTSensor):
    def __init__(self):
        super().__init__()
        self._name = "Upstairs thermometer (Jim)"
        self._period = 30
        self._url = "http://172.30.31.190"

        self._re = re.compile(r"celciusTemp: ([\d\.]*)")

        """
        Ëxample text/plain response:

        # HELP home_sensor_temperature_celcius Home temperature sensor reading
        # TYPE home_sensor_temperature_celcius gauge
        home_sensor_temperature_celciusTemp: 27.25

        """

    def processResponse(self, response: requests.Response) -> dict:
        values = {}
        result = self._re.search(response.text)
        if result:
            values["Temperature"] = float(matches[0])
        else:
            values["Temperature"] = None

        self._state = response.status_code
        self._values = values
