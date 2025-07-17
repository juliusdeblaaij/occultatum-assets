from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from components.occultatum.image_to_glb import image_to_glb
from components.occultatum.simple_object_storage import put_object, get_presigned_url, get_object
import httpx
import datetime

httpx_client = httpx.AsyncClient()

bucket_name = "models"

app = FastAPI()

@app.get("/artifact")
async def create_artifact(
    artifact_id: str,
    image_url: str
):
    image_file_name = image_url.split("/")[-1]

    image_data = await get_object(bucket_name, f"{artifact_id}/{image_file_name}")

    if not image_data:

        response = await httpx_client.get(image_url)
        if response.status_code != 200:
            print(f"Failed to download image from {image_url}: {response.status_code} {response.text}")
            raise HTTPException(status_code=400, detail="Failed to download image")
        image_data = response.content

        if not (response.headers["Content-Type"] == 'image/jpeg' or response.headers["Content-Type"] == 'image/png'):
            raise HTTPException(status_code=400, detail=f"{response.headers['Content-Type']} is not an allowed content type. Only JPEG or PNG are allowed.")

        await put_object(bucket_name, f"{artifact_id}/{image_file_name}", image_data, content_type=response.headers["Content-Type"])


    model_object_name = f"{artifact_id}/model.glb"
    model_file = await get_object(bucket_name, model_object_name)

    if not model_file:
        model_data = image_to_glb(image_data)
        await put_object(bucket_name, model_object_name, model_data, content_type="model/gltf-binary")

    # Set expiry to e.g. 3600 seconds (1 hour)
    expires = datetime.timedelta(seconds=3600)
    presigned_url = await get_presigned_url("GET", bucket_name, model_object_name, expires=expires)

    response = RedirectResponse(url=presigned_url, status_code=303)
    return response