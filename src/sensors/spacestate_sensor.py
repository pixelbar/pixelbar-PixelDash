import requests

from .rest_sensor import RESTSensor

class SpaceStateSensor(RESTSensor):
    def __init__(self):
        super().__init__()
        self._name = "Spacestate"
        self._interval = 10
        self._url = "https://spacestate.pixelbar.nl/spacestate.php"

        """
        Example application/json response:

        {
            "state": "closed"
        }

        """

    def _processResponse(self, response: requests.Response) -> dict:
        response_json = response.json()
        values = {"open": response_json["state"] == "open"}

        self._state = response.status_code
        self._values = values
