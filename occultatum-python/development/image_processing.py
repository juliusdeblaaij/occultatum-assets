from components.occultatum.crop_image_to_foreground.core import crop_image_to_foreground
from components.occultatum.isolate_artifact import isolate_artifact
from PIL import Image
import io
import os
#===

if __name__ == "__main__":
    rel_path = "sherd_with_bar.jpg"
    abs_file_path = os.path.join(os.path.dirname(__file__), rel_path)
    in_file = open(abs_file_path, "rb") # opening for [r]eading as [b]inary
    data = in_file.read() # if you only wanted to read 512 bytes, do .read(512)
    in_file.close()

    

