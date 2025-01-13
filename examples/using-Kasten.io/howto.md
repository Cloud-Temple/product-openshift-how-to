# How to Configure an S3 SNC Location in Kasten with Cloud Temple

## Steps to Configure S3 in Kasten:

1. **Access the Kasten Interface**:  
   - Open the Kasten dashboard via the OpenShift GUI.

2. **Configure the S3 Profile in Kasten**:  
   - Navigate to the **"Locations"** section in the Kasten dashboard.  
   - Create a new location profile with the following parameters:  
     - **Region**: `FR1`  
     - **Bucket Name**: `demobackup`  
     - **Endpoint**: `xxxxx.s3.fr1.cloud-temple.com`  
     - **Access Key**: Your provided access key  
     - **Secret Key**: Your provided secret key  

## Additional Resources  
For more details, visit the official Kasten documentation: [https://docs.kasten.io/](https://docs.kasten.io/)
