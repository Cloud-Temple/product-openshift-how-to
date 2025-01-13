# PVC Examples

## 1. RWX PersistentVolumeClaim  
**Description**: Allows multiple pods to mount the volume **read-write** simultaneously.  
- **Access Mode**: `ReadWriteMany` (RWX)  
- **Use Case**: Shared file storage accessible by multiple pods, useful for applications that require shared data.  

## 2. RWO PersistentVolumeClaim  
**Description**: Allows the volume to be mounted as **read-write** by a single node only.  
- **Access Mode**: `ReadWriteOnce` (RWO)  
- **Use Case**: Exclusive access to the volume, ideal for workloads running on a single node.  

## 3. ObjectBucketClaim (Ceph RGW)  
**Description**: Creates an **S3-compatible** object bucket using **Ceph RGW** (RADOS Gateway).  
- **Bucket Name**: Auto-generated as `test-claim-obc`.  
- **Purpose**: Provides object storage for applications requiring S3 buckets for storing large objects.  
- **Use Case**: Suitable for logs, backups, or large-scale object data.  
- **Remark**: Kasten **cannot back it up**.  


## 4. ObjectBucketClaim (Noobaa)  
**Description**: Creates an **S3-compatible** object bucket using **Noobaa** for object storage.  
- **Bucket Name**: Auto-generated as `test-claim-nooba`.  
- **Purpose**: Lightweight object storage platform.  
- **Use Case**: Suitable for multi-cloud and hybrid environments.  
- **Remark**: Kasten **cannot back it up**.  

## 5. SNC Cloud Temple S3  
**Description**: External **S3 storage** that is **not part of the cluster**.  
- **Purpose**: Provides object storage outside the cluster.  
- **Use Case**: Ideal for exporting Kasten backups.  
- **Remark**: Suitable for multi-cloud and hybrid environments.  

## Performance information : 

| **Storage Type**       | **Operation** | **Data Transferred**       | **Time Taken** | **Speed**          |
|-------------------------|---------------|----------------------------|----------------|--------------------|
| **cephfs-rwx**          | Write         | 42,949,591,040 bytes (43 GB) | 151.88 s       | 283 MB/s          |
|                         | Read          | 42,949,591,040 bytes (43 GB) | 84.2441 s      | 510 MB/s          |
| **cephrdb-rwo**         | Write         | 42,949,591,040 bytes (43 GB) | 225.258 s      | 191 MB/s          |
|                         | Read          | 42,949,591,040 bytes (43 GB) | 308.473 s      | 139 MB/s          |
| **cephobc (bucket)**    | Write         | 8,589,934,592 bytes (8.6 GB)  | -              | 88.8 MiB/s        |
|                         | Read          | 8,589,934,592 bytes (8.6 GB)  | 3.80435 s      | 2.3 GB/s          |
| **noobaobc (bucket)**   | Write         | 8,589,934,592 bytes (8.6 GB)  | -              | 41.5 MiB/s        |
|                         | Read          | 8,589,934,592 bytes (8.6 GB)  | 4.11676 s      | 2.1 GB/s          |
| **S3 SNC CT**             | Write         | 8,589,934,592 bytes (8.6 GB)  | -              | 177.0 MiB/s       |
|                         | Read          | 8,589,934,592 bytes (8.6 GB)  | 4.16444 s      | 2.1 GB/s          |
