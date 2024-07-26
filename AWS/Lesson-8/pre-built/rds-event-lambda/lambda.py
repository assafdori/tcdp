import json
import boto3
import os
from datetime import datetime

s3 = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    # Extract information from the event
    log_data = {
        'timestamp': datetime.utcnow().isoformat(),
        'message': event
    }

    # Define the log file name
    log_file_name = f"ads_logs/{datetime.utcnow().strftime('%Y-%m-%d_%H-%M-%S')}.json"

    # Convert the log data to JSON and store it in S3
    s3.put_object(
        Bucket=bucket_name,
        Key=log_file_name,
        Body=json.dumps(log_data)
    )

    return {
        'statusCode': 200,
        'body': json.dumps('Log stored successfully!')
    }
