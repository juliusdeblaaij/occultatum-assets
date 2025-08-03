from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse
from components.occultatum.image_to_glb import image_to_glb
from components.occultatum.simple_object_storage import put_object, get_presigned_url, get_object
import httpx

httpx_client = httpx.AsyncClient()

bucket_name = "models"

app = FastAPI()

@app.get("/artifact")
async def create_artifact(
    artifact_id: str,
    image_url: str,
    request: Request,
    mesh_resolution: int = 256
):
    model_object_name = f"{artifact_id}/model@{mesh_resolution}.glb"
    model_file = await get_object(bucket_name, model_object_name)

    model_url = f"{request.url.scheme}://{request.url.hostname}:9000/{bucket_name}/{model_object_name}"
    response = RedirectResponse(url=model_url, status_code=303)

    if model_file:
        return response

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

    if not model_file:
        model_data = image_to_glb(image_data, mesh_resolution)
        await put_object(bucket_name, model_object_name, model_data, content_type="model/gltf-binary")

    return response
