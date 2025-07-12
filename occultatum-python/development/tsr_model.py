from components.occultatum.tsr.system import TSR
from PIL import Image
import os
import torch
import numpy as np

if __name__ == "__main__":
    # Example usage of the get_triposr_model function
    model = TSR.from_pretrained(
        pretrained_model_name_or_path="stabilityai/TripoSR",
        config_name="config.yaml",
        weight_name="model.ckpt",
    )
    model.renderer.set_chunk_size(8192)
    model.to("cpu")

    image = Image.open("no_bg_no_bar_filtered_small_blobs_cropped.png")

    image = np.array(image).astype(np.float32) / 255.0
    image = image[:, :, :3] * image[:, :, 3:4] + (1 - image[:, :, 3:4]) * 0.5
    image = Image.fromarray((image * 255.0).astype(np.uint8))
    image.save('input.png')

    with torch.no_grad():
        scene_codes = model([image], device="cpu")
    
    meshes = model.extract_mesh(scene_codes, True, resolution=256)

    meshes[0].export("test.glb")