import logging
import subprocess

from .emitter import Emitter


class VCGenCmdEmitter(Emitter):
    def __init__(self) -> None:
        super().__init__()

        self._command = "vcgencmd"
        self._legal_commands = [
            "display_power"
        ]


    def _processValues(self, values: dict):
        for key, value in values.items():
            if key not in self._legal_commands:
                logging.error("Tried to execute unknown vcgencmd: %s", key)
                continue

            response = subprocess.Popen(
                f"{self._command} {key} {value}",
                shell=True,
                stdin=None,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                close_fds=True,
            )
