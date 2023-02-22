import json
import logging

import requests

from .emitter import Emitter


class LightsEmitter(Emitter):
    def __init__(self) -> None:
        super().__init__()
        self._timeout = 1
        self._interval = 0.1

        self._url = "http://172.30.31.86:1234/api/v2"
        self._headers = {"content-type": "application/json"}

        self._group_order = ["Beamer", "Door", "Stairs", "Kitchen"]

    def _processValues(self, values: dict):
        data = {}
        try:
            data["colors"] = [values[key] for key in self._group_order]
        except KeyError:
            logging.error("Missing group in values: %s", str(list(values.keys())))

        if not data:
            return

        try:
            result = requests.post(
                self._url,
                data=json.dumps(data),
                headers=self._headers,
                timeout=self._timeout,
            )
        except requests.exceptions.Timeout:
            logging.error("Timeout occurred while sending data to light server")
        except Exception as e:
            logging.error(
                "Exception occured while sending data to light server: %s", repr(e)
            )
