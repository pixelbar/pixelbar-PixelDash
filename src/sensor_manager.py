import logging
import sys
import types

from PySide2.QtQml import QQmlPropertyMap

from .sensors import *


class SensorManager(QQmlPropertyMap):
    def __init__(self):
        QQmlPropertyMap.__init__(self)

        # get a list of imported sensor modules
        module_dict = sys.modules["src.sensors"].__dict__
        sensor_modules = [
            module_obj
            for _, module_obj in module_dict.items()
            if (
                isinstance(module_obj, types.ModuleType)
                and module_obj.__name__.startswith("src.sensors")
            )
        ]

        for sensor_module in sensor_modules:
            # get the classes defined in the module
            classes = [
                sensor_obj
                for (_, sensor_obj) in sensor_module.__dict__.items()
                if (
                    isinstance(sensor_obj, type)
                    and sensor_obj.__module__ == sensor_module.__name__
                )
            ]
            if not classes:
                continue
            sensor_class = classes[0]

            # filter out super classes that should not be used on their own
            class_name = sensor_class.__name__[:-6]
            if class_name in ["", "REST", "CommandLine"]:
                continue

            logging.info("Creating %s sensor", class_name)
            sensor_instance = sensor_class()
            sensor_instance.start()

            self.insert(class_name, sensor_instance)

    def stop(self):
        for key in self.keys():
            logging.info("Closing %s sensor", key)
            try:
                self.value(key).stop()
            except AttributeError:
                pass
            self.clear(key)
