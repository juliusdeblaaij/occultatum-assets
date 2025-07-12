import numpy as np
from PIL import Image
import io

def crop_image_to_foreground(image_data: bytes):

    image = Image.open(io.BytesIO(image_data))

    source_image_no_bg_raw = np.array(image)
    alpha_channel = source_image_no_bg_raw[:, :, 3]
    non_zero_pixels = np.where(alpha_channel > 0)

    min_x, max_x = np.min(non_zero_pixels[1]), np.max(non_zero_pixels[1])
    min_y, max_y = np.min(non_zero_pixels[0]), np.max(non_zero_pixels[0])
    size = max(max_x - min_x, max_y - min_y)
    center_x, center_y = (min_x + max_x) // 2, (min_y + max_y) // 2

    new_min_x = max(0, center_x - size // 2)
    new_max_x = center_x + size // 2
    new_min_y = max(0, center_y - size // 2)
    new_max_y = center_y + size // 2

    new_image = Image.fromarray(source_image_no_bg_raw[new_min_y:new_max_y, new_min_x:new_max_x])

    image_byte_array = io.BytesIO()
    new_image.save(image_byte_array, format=image.format)
    return image_byte_array.getvalue()