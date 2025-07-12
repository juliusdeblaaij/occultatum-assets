def artifact_to_3d_cli(artifact_image_data: bytes, model_data: bytes) -> None:
    """
    Convert an artifact to a 3D model and save it to the specified output path.
    
    Args:
        artifact_image_data (bytes): JPEG or PNG image data.
        model_data (bytes): 3D model data (default in GLB format).
    """
    pass

from PIL import Image
import numpy as np
#from TripoSR.tsr.utils import remove_background
import cv2



def remove_background(image, black_threshold=20, white_threshold=230, dilation_kernel_size=15, min_blob_area=200):
    # Convert PIL image to an OpenCV-compatible NumPy array
    if image.mode != 'RGBA':
        image = image.convert('RGBA')
    img_np = np.array(image)
    
    # Create a binary mask based on the color thresholds
    # Separate the RGB channels from the alpha channel
    rgb = img_np[:, :, :3]
    
    # Find pixels that are near-black or near-white
    is_near_black = np.all(rgb < black_threshold, axis=-1)
    is_near_white = np.all(rgb > white_threshold, axis=-1)
    
    # Combine the conditions into a single mask.
    # np.where assigns 255 (white) if the condition is true, 0 (black) otherwise.
    mask = np.where(is_near_black | is_near_white, 255, 0).astype(np.uint8)

    # Filter out small blobs.
    # Find all connected components (blobs) in the mask.
    num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, 4, cv2.CV_32S)
    
    # Create a new mask to store only the large blobs.
    filtered_mask = np.zeros_like(mask)
    
    # Iterate through each component, starting from 1 (0 is the background).
    for i in range(1, num_labels):
        # If the area of the component is greater than the minimum, add it to the new mask.
        if stats[i, cv2.CC_STAT_AREA] >= min_blob_area:
            filtered_mask[labels == i] = 255
    
    # Create a kernel for dilation. A larger kernel size means more expansion.
    kernel = np.ones((dilation_kernel_size, dilation_kernel_size), np.uint8)
    
    # Expand the white areas (the blobs) in the mask to cover surrounding pixels
    dilated_mask = cv2.dilate(filtered_mask, kernel, iterations=1)
    
    # Use the dilated mask to update the alpha channel of the original image.
    # Where the mask is 255, set the alpha channel to 0 (fully transparent).
    img_np[dilated_mask == 255, 3] = 0
    
    # Filter pixels by alpha value. Keep only pixels with alpha > 245.
    alpha_channel = img_np[:, :, 3]
    img_np[alpha_channel <= 245, 3] = 0

    # Convert the NumPy array back to a PIL Image
    result_img = Image.fromarray(img_np)
    return result_img

if(__name__ == '__main__'):
    image = crop_image_to_square(Image.open('vdm-20155007-3-13-45-15.jpg'))
    image.save('cropped_image.png')