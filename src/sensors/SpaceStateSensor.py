from .RESTSensor import RESTSensor

import requests


class SpaceStateSensor(RESTSensor):
    def __init__(self):
        super().__init__()
        self._name = "Spacestate"
        self._interval = 10
        self._url = "https://spacestate.pixelbar.nl/spacestate.php"

        """
        Ëxample application/json response:

        {
            "state": "closed"
        }

        """

    def processResponse(self, response: requests.Response) -> dict:
        response_json = response.json()
        values = {"open": response_json["state"] == "open"}

        self._state = response.status_code
        self._values = values
