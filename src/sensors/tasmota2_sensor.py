import requests

from .rest_sensor import RESTSensor


class Tasmota2Sensor(RESTSensor):
    def __init__(self, config):
        super().__init__()
        self._name = "Climate (upstairs)"
        self._config = config

        self._interval = 30
        self._url = "{0}/cm?cmnd=STATUS%2010".format(self._config["url"])

        self._unit_map = {
            "Temperature": "°C",
            "Humidity": "%",
            "DewPoint": "°C",
            "Pressure": "hPa"
        }

        """
        Example application/json response:

        {
            "StatusSNS": {
                "Time": "2023-01-07T20:23:05",
                "BME280": {
                    "Temperature": 28.6,
                    "Humidity": 42.4,
                    "DewPoint": 14.6,
                    "Pressure": 1011.8
                },
                "PressureUnit": "hPa",
                "TempUnit": "C"
            }
        }

        Corresponding text:

        BME280 Temperature  28.6 °C
        BME280 Humidity     42.4 %
        BME280 Dew point    14.6 °C
        BME280 Pressure     1011.8 hPa
        """

    def _processResponse(self, response: requests.Response) -> dict:
        response_json = response.json()
        values = response_json["StatusSNS"]["BME280"]

        self._state = response.status_code
        self._values = values
