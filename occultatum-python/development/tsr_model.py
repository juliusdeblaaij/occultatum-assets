from PIL import Image
import os
import torch
import numpy as np
from components.occultatum.image_to_glb import image_to_glb

if __name__ == "__main__":
    # # Example usage of the get_triposr_model function
    # model = TSR.from_pretrained(
    #     pretrained_model_name_or_path="stabilityai/TripoSR",
    #     config_name="config.yaml",
    #     weight_name="model.ckpt",
    # )
    # model.renderer.set_chunk_size(8192)
    # model.to("cpu")

    # image = Image.open("no_bg_no_bar_filtered_small_blobs_cropped.png")

    # image = np.array(image).astype(np.float32) / 255.0
    # image = image[:, :, :3] * image[:, :, 3:4] + (1 - image[:, :, 3:4]) * 0.5
    # image = Image.fromarray((image * 255.0).astype(np.uint8))
    # image.save('input.png')

    # with torch.no_grad():
    #     scene_codes = model([image], device="cpu")
    
    # meshes = model.extract_mesh(scene_codes, True, resolution=256)

    # meshes[0].export("test.glb")

    #rel_path = "sherd_with_bar.jpg"
    rel_path = "24-photo-20090231-profile.jpg"
    abs_file_path = os.path.join(os.path.dirname(__file__), rel_path)
    in_file = open(abs_file_path, "rb") # opening for [r]eading as [b]inary
    data = in_file.read() # if you only wanted to read 512 bytes, do .read(512)
    in_file.close()

    model_data = image_to_glb(data)

    with open("output.glb", "wb") as f:
        f.write(model_data)
