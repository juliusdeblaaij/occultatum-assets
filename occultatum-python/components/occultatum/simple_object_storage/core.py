from miniopy_async import Minio
from io import BytesIO

client = Minio(
    endpoint="127.0.0.1:9000",
    access_key="minioadmin",
    secret_key="minioadmin",
    secure=False  # Use HTTP instead of HTTPS
)

async def put_object(bucket_name: str, object_name: str, file_contents: bytes, content_type: str = "application/octet-stream"):
    length = len(file_contents)
    await client.put_object(bucket_name, object_name, BytesIO(file_contents), length, content_type)

async def get_presigned_url(method: str, bucket_name: str, object_name: str):
    url = await client.get_presigned_url(method=method, bucket_name=bucket_name, object_name=object_name, expires=3600)

    return url
