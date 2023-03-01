from typing import Any, Dict

class Config:
    """
    This class represents a deserialized TOML config file for PixelDash configuration
    """

    def __init__(self, config: dict[str, Any]) -> None:
        # TODO: When TOML decides on a schema format, we should validate the config here
        self.debug = config["pixeldash"]["debug"]
        self.log_path = config["pixeldash"]["log_path"]

        self._config = config


    def config_for(self, name) -> Dict[str, Any]:
        return self._config.get(name)
