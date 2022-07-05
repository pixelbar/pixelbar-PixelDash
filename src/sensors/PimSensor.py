from .RESTSensor import RESTSensor

import requests


class PimSensor(RESTSensor):
    def __init__(self):
        super().__init__()
        self._name = "Kitchen thermometer (Pim)"
        self._period = 30
        self._url = "http://172.30.31.86:8080/temp.json"

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

    def processResponse(self, response: requests.Response) -> dict:
        response_json = response.json()
        values = {"Temperature": float(response_json["AccelTemp"])}

        self._state = response.status_code
        self._values = values
