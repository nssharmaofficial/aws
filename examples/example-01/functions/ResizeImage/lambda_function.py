import boto3
import os
import uuid
from urllib.parse import unquote_plus
from PIL import Image

s3_client = boto3.client('s3')

def resize_image(image_path, resized_path):
    with Image.open(image_path) as image:
        image.thumbnail(tuple(x // 2 for x in image.size))
        image.save(resized_path, 'PNG')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = 'resize-image-demo-ns'  # specify the bucket name
        key = unquote_plus(record['s3']['object']['key'])

        if not key.startswith('original/'):
            print(f"Ignoring object {key} as it does not start with 'original/'")
            continue

        tmpkey = key.replace('/', '')
        download_path = f'/tmp/{uuid.uuid4()}{tmpkey}'
        upload_key = key.replace('original/', 'resized/')
        upload_path = f'/tmp/resized-{tmpkey}'

        s3_client.download_file(bucket, key, download_path)
        resize_image(download_path, upload_path)
        s3_client.upload_file(upload_path, bucket, upload_key)

        # Cleanup
        os.remove(download_path)
        os.remove(upload_path)

    return {
        'statusCode': 200,
        'body': 'Images resized and uploaded successfully!'
    }
