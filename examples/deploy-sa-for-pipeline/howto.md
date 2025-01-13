# Deploy-sa-for-pipeline

This manifest deploys a simple ServiceAccount in the namespace, grants full permissions within the namespace, and creates a token.
You can retrieve the token afterward with the following commands:

1. Switch to the target namespace:  
   ```bash
   oc project democonsole
   ```
2. Retrieve and decode the token:  
   ```bash
   oc get secret my-sa-demo-token -o jsonpath='{.data.token}' | base64 -d
   ```
This ServiceAccount can be used in your CI pipeline, for example:
- To push a Docker image.
- To interact with the Kubernetes API within the specified namespace.
