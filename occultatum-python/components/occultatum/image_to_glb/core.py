import torch
from huggingface_hub import hf_hub_download
from PIL import Image
import numpy as np
from components.occultatum.triposr_model import initialize_model, image_to_3d
from components.occultatum.isolate_artifact import isolate_artifact

initialize_model()

def image_to_glb(image_data: bytes, mesh_resolution: int = 256) -> bytes:

    image_data = isolate_artifact(image_data)

    return image_to_3d(image_data, 'glb', mesh_resolution)

    