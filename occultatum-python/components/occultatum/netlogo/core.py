import os

import pynetlogo
jvm_path = os.path.join(os.environ["JAVA_HOME"], "lib", "server", "libjvm.so")

_netlogo = pynetlogo.NetLogoLink(
    gui=False,
    jvm_path=jvm_path,
)

def load_model(model_path):
    if not os.path.exists(model_path):
        raise FileNotFoundError(f"Model file does not exist: {model_path}")
    _netlogo.load_model(model_path)

def command(command):
    if not command:
        raise ValueError("Command cannot be empty")
    _netlogo.command(command)

def kill():
    _netlogo.kill_workspace()