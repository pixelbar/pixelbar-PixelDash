import logging
import sys
import types

from PySide2.QtQml import QQmlPropertyMap

from .emitters import *


class EmitterManager(QQmlPropertyMap):
    def __init__(self):
        QQmlPropertyMap.__init__(self)

        # get a list of imported emitter modules
        module_dict = sys.modules["src.emitters"].__dict__
        emitter_modules = [
            module_obj
            for _, module_obj in module_dict.items()
            if (
                isinstance(module_obj, types.ModuleType)
                and module_obj.__name__.startswith("src.emitters")
            )
        ]

        for emitter_module in emitter_modules:
            # get the classes defined in the module
            classes = [
                emitter_obj
                for (_, emitter_obj) in emitter_module.__dict__.items()
                if (
                    isinstance(emitter_obj, type)
                    and emitter_obj.__module__ == emitter_module.__name__
                )
            ]
            if not classes:
                continue
            emitter_class = classes[0]

            # filter out super classes that should not be used on their own
            class_name = emitter_class.__name__[:-7]
            if class_name in [""]:
                continue

            logging.info("Creating %s emitter", class_name)
            emitter_instance = emitter_class()
            emitter_instance.start()

            self.insert(class_name, emitter_instance)

    def stop(self):
        for key in self.keys():
            logging.info("Closing %s emitter", key)
            print(self.value(key))
            self.value(key).stop()
            self.clear(key)
