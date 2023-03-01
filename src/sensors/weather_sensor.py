import requests

from .rest_sensor import RESTSensor


class WeatherSensor(RESTSensor):
    def __init__(self, config):
        super().__init__()
        self._name = "Weather"
        self._config = config

        self._interval = 60
        api_key = self._config["api_key"]
        self._url = f"http://api.weatherapi.com/v1/current.json?key={api_key}&q=Rotterdam&aqi=yes"

        self._unit_map = {
            "Temperature": "°C",
            "Cloud": "%",
            "Precipitation": "%",
            "Wind": "km/h",
            "PM2.5": "µg/m³"
        }

        """
        Example application/json response:

        {
            "location": {
                "name": "Rotterdam",
                "region": "South Holland",
                "country": "Netherlands",
                "lat": 51.92,
                "lon": 4.48,
                "tz_id": "Europe/Amsterdam",
                "localtime_epoch": 1656236624,
                "localtime": "2022-06-26 11:43"
            },
            "current": {
                "last_updated_epoch": 1656235800,
                "last_updated": "2022-06-26 11:30",
                "temp_c": 19.0,
                "temp_f": 66.2,
                "is_day": 1,
                "condition": {
                    "text": "Partly cloudy",
                    "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                    "code": 1003
                },
                "wind_mph": 6.9,
                "wind_kph": 11.2,
                "wind_degree": 170,
                "wind_dir": "S",
                "pressure_mb": 1015.0,
                "pressure_in": 29.97,
                "precip_mm": 0.0,
                "precip_in": 0.0,
                "humidity": 64,
                "cloud": 50,
                "feelslike_c": 19.0,
                "feelslike_f": 66.2,
                "vis_km": 10.0,
                "vis_miles": 6.0,
                "uv": 5.0,
                "gust_mph": 11.0,
                "gust_kph": 17.6,
                "air_quality": {
                    "co": 178.60000610351562,
                    "no2": 7.800000190734863,
                    "o3": 56.5,
                    "so2": 2.5,
                    "pm2_5": 2.700000047683716,
                    "pm10": 3.5,
                    "us-epa-index": 1,
                    "gb-defra-index": 1
                }
            }
        }
        """

    def _processResponse(self, response: requests.Response) -> dict:
        response_json = response.json()
        values = {
            "Temperature": response_json["current"]["temp_c"],
            "Cloud": response_json["current"]["cloud"],
            "Precipitation": response_json["current"]["precip_mm"],
            "Wind": response_json["current"]["wind_kph"],
            "PM2.5": round(response_json["current"]["air_quality"]["pm2_5"], 2)
        }

        self._state = response.status_code
        self._values = values
