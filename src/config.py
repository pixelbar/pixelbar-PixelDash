from typing import Any

class Config:
    """
    This class represents a deserialized TOML config file for PixelDash configuration
    """
    def __init__(self, config: dict[str, Any]) -> None:
        # TODO: When TOML decides on a schema format, we should validate the config here
        self.debug = config["pixeldash"]["debug"]
        self.log_path = config["pixeldash"]["log_path"]

        self._configs = {
            "IKEASensor": IKEAConfig(config["IKEASensor"]),
            "JimSensor": JimConfig(config["JimSensor"]),
            "PimSensor": PimConfig(config["PimSensor"]),
            "Tasmota2Sensor": Tasmota2Config(config["Tasmota2Sensor"]),
            "WeatherSensor": WeatherConfig(config["WeatherSensor"]),
        }


    def config_for(self, name: str):
        return self._configs.get(name)


class IKEAConfig:
    """
    This class represents the configuration of the IKEA Sensor Object
    """
    def __init__(self, config: dict[str, Any]) -> None:
        self.url = config["url"]


class JimConfig:
    """
    This class represents the configuration of the Jim Sensor Object
    """
    def __init__(self, config: dict[str, Any]) -> None:
        self.url = config["url"]


class PimConfig:
    """
    This class represents the configuration of the Pim Sensor Object
    """
    def __init__(self, config: dict[str, Any]) -> None:
        self.url = config["url"]


class Tasmota2Config:
    """
    This class represents the configuration of the Tasmota2 Sensor Object
    """
    def __init__(self, config: dict[str, Any]) -> None:
        self.url = config["url"]


class WeatherConfig:
    """
    This class represents the configuration of the Weather Sensor Object
    """
    def __init__(self, config: dict[str, Any]) -> None:
        self.api_key = config["api_key"]
