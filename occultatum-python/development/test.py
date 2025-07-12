from components.occultatum.crop_image_to_foreground.core import crop_image_to_foreground
from components.occultatum.isolate_artifact.core import remove_background, remove_measurement_bar
from PIL import Image
import io
import os

if __name__ == "__main__":
    rel_path = "sherd_with_bar.jpg"
    abs_file_path = os.path.join(os.path.dirname(__file__), rel_path)
    in_file = open(abs_file_path, "rb") # opening for [r]eading as [b]inary
    data = in_file.read() # if you only wanted to read 512 bytes, do .read(512)
    in_file.close()

    data = remove_background(data)

    image = Image.open(io.BytesIO(data))
    image.save('no_bg.png')

    data = remove_measurement_bar(data, 
        black_threshold=30, 
        white_threshold=235, 
        dilation_kernel_size=15, 
        min_blob_area=1000)
    
    image = Image.open(io.BytesIO(data))
    image.save('no_bg_no_bar.png')

    data = crop_image_to_foreground(data)
    image = Image.open(io.BytesIO(data))
    image.save('no_bg_no_bar_cropped.png')

    