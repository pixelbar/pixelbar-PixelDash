import requests

from .Controller import Controller


class LightsController(Controller):
    def __init__(self) -> None:
        super().__init__()

        self._url = "http://172.30.31.86:1234/api/v2"
        self._headers = {"content-type": "application/json"}

        self._group_order = ["Beamer", "Door", "Stairs", "Kitchen"]

    def processValues(self, values: dict):
        data = {}
        try:
            data["colors"] = [values[key] for key in self._group_order]
        except KeyError:
            print("Missing group in values: " + str(list(values.keys())))

        if not data:
            return

        try:
            result = requests.post(self._url, data=json.dumps(data), headers=self._headers)
        except Exception as e:
            print("Exception occured while sending data to light server: " + repr(e))