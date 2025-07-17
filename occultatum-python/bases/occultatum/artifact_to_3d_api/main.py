from fastapi import FastAPI, HTTPException, Form
from components.occultatum.artifact_to_3d import artifact_to_3d
from components.occultatum.simple_object_storage import put_object, get_presigned_url
import httpx

bucket_name = "models"

app = FastAPI()

@app.post("/create_artifact")
async def create_artifact(
    artifact_id: str,
    image_url: str
):
    # download image from the URL
    async with httpx.AsyncClient() as client:
        response = await client.get(image_url)
        if response.status_code != 200:
            raise HTTPException(status_code=400, detail="Failed to download image")
        file_data = response.content

    if not (response.headers["Content-Type"] == 'image/jpeg' or response.headers["Content-Type"] == 'image/png'):
        raise HTTPException(status_code=400, detail=f"{response.headers['Content-Type']} is not an allowed content type. Only JPEG or PNG are allowed.")

    await put_object(bucket_name, f"{artifact_id}/{image_url.split('/')[-1]}", file_data, content_type=response.headers["Content-Type"])

    model_data = artifact_to_3d(file_data)

    await put_object(bucket_name, f"{artifact_id}/model.glb", model_data, content_type="model/gltf-binary")

    presigned_url = await get_presigned_url("GET", bucket_name, f"{artifact_id}/model.glb")

    return {"artifact_id": artifact_id, "presigned_url": presigned_url}