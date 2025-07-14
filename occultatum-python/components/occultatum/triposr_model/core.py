from .tsr.system import TSR
from PIL import Image
import numpy as np
import io
import torch
from enum import Enum

_model = None
_device = 'cpu'

class Format(Enum):
    GLB = 'glb'
    OBJ = 'obj'

def initialize_model(device: str = 'cpu'):
    global _model, _device
    if(_model is None):
        _model = TSR.from_pretrained(
            pretrained_model_name_or_path="stabilityai/TripoSR",
            config_name="config.yaml",
            weight_name="model.ckpt",
        )
        _model.renderer.set_chunk_size(8192)

        _device = device
        _model.to(device)

    return _model

def image_to_3d(image_data: bytes, format: Format) -> bytes:    

    image = Image.open(io.BytesIO(image_data))

    image = np.array(image).astype(np.float32) / 255.0
    image = image[:, :, :3] * image[:, :, 3:4] + (1 - image[:, :, 3:4]) * 0.5
    image = Image.fromarray((image * 255.0).astype(np.uint8))

    with torch.no_grad():
        scene_codes = _model([image], device=_device)
    
    meshes = _model.extract_mesh(scene_codes, True, resolution=256)

    if format == Format.OBJ.value:
        from trimesh.exchange.obj import export_obj
        return export_obj(meshes[0])
    elif format == Format.GLB.value:
        from trimesh.exchange.gltf import export_glb
        return export_glb(meshes[0])