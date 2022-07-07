from .RESTSensor import RESTSensor

import requests


class IKEASensor(RESTSensor):
    def __init__(self):
        super().__init__()
        self._name = "IKEA air quality"

        self._interval = 30
        self._url = "http://172.30.31.116/cm?cmnd=STATUS%2010"

        self._unitMap = {
            "Temperature": "°C",
            "Humidity": "%",
            "DewPoint": "°C",
            "Pressure": "hPa",
            "Gas": "kΩ",
            "PM2.5": "µg/m³"
        }

        """
        Ëxample application/json response:

        {
            "StatusSNS": {
                "Time": "2022-06-25T21:35:51",
                "BME680": {
                    "Temperature": 28.6,
                    "Humidity": 42.4,
                    "DewPoint": 14.6,
                    "Pressure": 1011.8,
                    "Gas": 76.18
                },
                "VINDRIKTNING": {
                    "PM2.5": 7
                },
                "PressureUnit": "hPa",
                "TempUnit": "C"
            }
        }

        Corresponding text:

        BME680 Temperature  28.6 °C
        BME680 Humidity     42.4 %
        BME680 Dew point    14.6 °C
        BME680 Pressure     1011.8 hPa
        BME680 Gas resistance   76.18 kΩ
        VINDRIKTNING PM 2.5 µm  7 µg/m³
        """

    def processResponse(self, response: requests.Response) -> dict:
        response_json = response.json()
        values = response_json["StatusSNS"]["BME680"]
        values["PM2.5"] = response_json["StatusSNS"]["VINDRIKTNING"]["PM2.5"]

        self._state = response.status_code
        self._values = values
