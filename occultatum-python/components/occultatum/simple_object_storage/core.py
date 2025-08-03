
from miniopy_async import Minio
from io import BytesIO
import os
from dotenv import load_dotenv

load_dotenv()

client = Minio(
    endpoint=os.getenv("MINIO_ENDPOINT", "127.0.0.1:9000"),
    access_key=os.getenv("MINIO_ACCESS_KEY"),
    secret_key=os.getenv("MINIO_SECRET_KEY"),
    secure=os.getenv("MINIO_SECURE", "false").lower() == "true"
)

async def put_object(bucket_name: str, object_name: str, file_contents: bytes, content_type: str = "application/octet-stream"):
    length = len(file_contents)
    await client.put_object(bucket_name, object_name, BytesIO(file_contents), length, content_type)

async def get_object(bucket_name: str, object_name: str):
    try:
        response = await client.get_object(bucket_name, object_name)
        return await response.read()
    except Exception as e:
        print(f"Error getting object {object_name} from bucket {bucket_name}: {e}")
        return None

async def get_presigned_url(method: str, bucket_name: str, object_name: str, expires: timedelta = timedelta(seconds=3600)):
    url = await client.get_presigned_url(method=method, bucket_name=bucket_name, object_name=object_name, expires=expires)

    print(f"Presigned URL for {object_name} in bucket {bucket_name}: {url}")
    return url
