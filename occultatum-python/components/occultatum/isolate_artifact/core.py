from PIL import Image
import cv2
import numpy as np
import rembg
import io
from occultatum.crop_image_to_foreground import crop_image_to_foreground

def isolate_artifact(image_data: bytes) -> bytes:
    data = remove_background(image_data)

    data = remove_measurement_bar(data, 
        black_threshold=30, 
        white_threshold=235, 
        dilation_kernel_size=15, 
        min_blob_area=1000)
    
    data = keep_large_blobs_only(data, min_blob_area_percent=2.0)

    data = crop_image_to_foreground(data)

    return data


def remove_measurement_bar(image_data: bytes, black_threshold=10, white_threshold=235, dilation_kernel_size=15, min_blob_area=200):
    """
    Removes near-black and near-white areas by creating a mask, filtering out small blobs,
    dilating it, and then making the pixels under the mask transparent.
    Only removes blobs that are not fully enclosed by "good" pixels (i.e., only removes blobs touching the image border).
    """
    img = Image.open(io.BytesIO(image_data)).convert("RGBA")

    # Convert PIL image to an OpenCV-compatible NumPy array
    img_np = np.array(img)
    
    # Create a binary mask based on the color thresholds
    # Separate the RGB channels from the alpha channel
    rgb = img_np[:, :, :3]
    
    # Find pixels that are near-black or near-white
    is_near_black = np.all(rgb < black_threshold, axis=-1)
    is_near_white = np.all(rgb > white_threshold, axis=-1)
    
    # Combine the conditions into a single mask.
    mask = np.where(is_near_black | is_near_white, 255, 0).astype(np.uint8)

    # Filter out small blobs.
    num_labels, labels, stats, centroids = cv2.connectedComponentsWithStats(mask, 4, cv2.CV_32S)
    
    # Create a new mask to store only the large blobs that touch the border.
    filtered_mask = np.zeros_like(mask)
    h, w = mask.shape

    for i in range(1, num_labels):
        if stats[i, cv2.CC_STAT_AREA] >= min_blob_area:
            # Get the bounding box of the blob
            x, y, bw, bh, area = stats[i]
            # Check if the blob touches the border
            touches_border = (
                x == 0 or y == 0 or (x + bw) == w or (y + bh) == h
            )
            if touches_border:
                filtered_mask[labels == i] = 255

    # Create a kernel for dilation. A larger kernel size means more expansion.
    kernel = np.ones((dilation_kernel_size, dilation_kernel_size), np.uint8)
    
    # Expand the white areas (the blobs) in the mask to cover surrounding pixels
    dilated_mask = cv2.dilate(filtered_mask, kernel, iterations=1)
    
    # Use the dilated mask to update the alpha channel of the original image.
    img_np[dilated_mask == 255, 3] = 0
    
    # Filter pixels by alpha value. Keep only pixels with alpha > 245.
    alpha_channel = img_np[:, :, 3]
    img_np[alpha_channel <= 245, 3] = 0

    # Convert the NumPy array back to a PIL Image
    result_img = Image.fromarray(img_np)
    
    image_bytes = io.BytesIO()
    result_img.save(image_bytes, format='PNG')
    return image_bytes.getvalue()

def remove_background(image_data: bytes):
    image = io.BytesIO(image_data).getvalue()

    image_data_no_bg = rembg.remove(image_data, force_return_bytes=True)

    return image_data_no_bg

def keep_large_blobs_only(image_data: bytes, min_blob_area_percent=1.0):
    """
    Keeps only pixels that are part of a blob with at least `min_blob_area_percent` percent of the image area.
    All other pixels are set to fully transparent.

    Args:
        image_data (bytes): PNG or JPEG image data.
        min_blob_area_percent (float): Minimum blob area as a percentage of the image area (0-100).
    """
    img = Image.open(io.BytesIO(image_data)).convert("RGBA")
    img_np = np.array(img)

    # Create a mask of non-transparent pixels
    alpha = img_np[:, :, 3]
    mask = (alpha > 0).astype(np.uint8) * 255

    # Find connected components (blobs)
    num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(mask, 4, cv2.CV_32S)

    # Calculate minimum area in pixels based on percentage
    img_area = img_np.shape[0] * img_np.shape[1]
    min_blob_area = int((min_blob_area_percent / 100.0) * img_area)

    # Create a mask to keep only large blobs
    keep_mask = np.zeros_like(mask)
    for i in range(1, num_labels):  # 0 is background
        if stats[i, cv2.CC_STAT_AREA] >= min_blob_area:
            keep_mask[labels == i] = 255

    # Set pixels not in large blobs to fully transparent
    img_np[keep_mask == 0, 3] = 0

    result_img = Image.fromarray(img_np)
    output = io.BytesIO()
    result_img.save(output, format='PNG')
    return output.getvalue()
