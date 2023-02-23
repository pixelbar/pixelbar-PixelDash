from typing import Any

class Config:
    """
    This class represents a deserialized TOML config file for PixelDash configuration
    """
    def __init__(self, config: dict[str, Any]) -> None:
        # TODO: When TOML decides on a schema format, we should validate the config here
        self.pixeldash = PixelDashConfig(config["pixeldash"])
        self.debug = self.pixeldash.debug
        self.log_path = self.pixeldash.log_path

        self.ikea = IKEAConfig(config["ikea"])
        self.jim = JimConfig(config["jim"])
        self.pim = PimConfig(config["pim"])
        self.tasmota2 = Tasmota2Config(config["tasmota2"])
        self.weather = WeatherConfig(config["weather"])


class PixelDashConfig:
    """
    This class represents the configuration of the general PixelDash project
    """
    def __init__(self, config: dict[str, Any]) -> None:
        self.debug = config["debug"]
        self.log_path = config["log_path"]


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
        self.api_key = config["api"]