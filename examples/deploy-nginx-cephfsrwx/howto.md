# Deploy `nginx-cephfsrwx`

This manifest deploys a simple **Nginx application** with **3 replicas**.  
It uses a **CephFS volume** to share the directory `/usr/share/nginx/html` across all replicas.


## Steps to Deploy and Copy `index.html`

1. Deploy the application using the provided manifest.

2. Once the deployment is complete, copy the `index.html` file to the shared directory using the following command:  

   ```bash
   oc cp index.html <nginx-pod-name>:/usr/share/nginx/html
   ```
Replace <nginx-pod-name> with the actual name of one of the Nginx pods, e.g., nginx-xxxxxxxxx-xxxxx.