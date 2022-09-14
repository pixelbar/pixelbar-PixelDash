from .RESTSensor import RESTSensor

import requests


class PimSensor(RESTSensor):
    def __init__(self):
        super().__init__()
        self._name = "Kitchen thermometer (Pim)"
        self._interval = 30
        self._url = "http://172.30.31.86:8080/temp.json"

        self._unitMap = {
            "Temperature": "°C"
        }

        """
        Ëxample application/json response:

        {
            "AccelTemp": "24.39",
            "AccelTijd": "1393571",
            "Acx": "532",
            "Acy": "-368",
            "Acz": "-18068",
            "Gyx": "-142",
            "Gyy": "71",
            "Gyz": "2430"
        }

        """

    def _processResponse(self, response: requests.Response) -> dict:
        try:
            response_json = response.json()
        except requests.exceptions.JSONDecodeError:
            self._state = 500
            return
        values = {"Temperature": float(response_json["AccelTemp"])}

        self._state = response.status_code
        self._values = values
