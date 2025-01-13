## How-to deploy

### 1. Install Prerequisites

Ensure all required tools mentioned in the Software version section are installed and properly configured.

- Install OpenShift CLI: [OCP CLI Guide](https://docs.redhat.com/en/documentation/openshift_container_platform/4.15/html/cli_tools/openshift-cli-oc#cli-getting-started)
- Install Helm and Helmfile: [Helmfile Guide](https://Helmfile.readthedocs.io/en/latest/)

---

### 2. Log In to the OpenShift Cluster

Authenticate with your OpenShift cluster.

First way, using token authentication.

```bash
oc login --server=https://api.openshift.example.com:6443 --web
```

>**Warning** :
> The login command will show the internal server URL in the --server argument, which you can't resolve from your computer.
> You will need to replace your "--server" url by :
**"--server=<https://api-ocp><number_of_your_cluster>-<cluster_name>.paas.cloud-temple.com"**

---

### 3. Create the project

In OpenShift project are inherited from NameSpaces.
Create a dedicated project to isolate the demonstration.

```bash
oc new-project poc-helmfile
```

---

### 4. Deploy Applications with Helmfile

Run the `Helmfile sync` command to deploy the specified Helm charts.

```bash
Helmfile sync
```

---

### 5. Verify the Deployment

- **Check Pods**: Ensure the pods are running.

  ```bash
  oc get pods -n poc-Helmfile
  ```

- **Validate UIDs**: Verify that the containers are running with the appropriate UIDs.
  
  ```bash
  oc describe pod <pod-name> -n poc-Helmfile
  ```

---

### 6. Test the Services

Expose the services to test accessibility and functionality.

First create routes.

Over HTTPS :

```bash
oc create route edge nginx-tls --service=nginx -n poc-Helmfile --port=8080 ## expose in HTTPS
````

Over HTTP :

```bash
oc create route edge nginx --service=nginx -n poc-Helmfile --port=8080 ## expose in HTTP
```

Then tag the route with the `ct-router-type=public` label to expose the service publicly.

```bash
oc label route nginx-tls ct-router-type=public -n poc-Helmfile 
```

```bash
oc label route nginx ct-router-type=public -n poc-Helmfile 
```

---

### 7. Verifying the Command

1. After running the command, list the routes to verify:

   ```bash
   oc get routes -n poc-Helmfile
   ```

   Output Example:

  | NAME      | HOST/PORT                                                                  | PATH   | SERVICES | PORT | TERMINATION | WILDCARD | LABELS                                                                                                            |
|-----------|---------------------------------------------------------------------------|--------|----------|------|-------------|----------|-------------------------------------------------------------------------------------------------------------------|
| nginx     | nginx-poc-Helmfile.apps-ocp<cluster_number>-<cluster_name>.paas.cloud-temple.com                   | nginx  | 8080     | edge | None        | None     | app.kubernetes.io/instance=nginx,app.kubernetes.io/managed-by=Helm,app.kubernetes.io/name=nginx,app.kubernetes.io/version=1.27.3,ct-router-type=public,Helm.sh/chart=nginx-18.2.6 |
| nginx-tls | nginx-tls-poc-Helmfile.apps-ocp<cluster_number>-<cluster_name>.paas.cloud-temple.com               | nginx  | 8080     | edge | None        | None     | app.kubernetes.io/instance=nginx,app.kubernetes.io/managed-by=Helm,app.kubernetes.io/name=nginx,app.kubernetes.io/version=1.27.3,ct-router-type=public,Helm.sh/chart=nginx-18.2.6 |

2. Access the application via the `HOST/PORT` field:
   - `http://nginx-tls-poc-Helmfile.apps-ocp<cluster_number>-<cluster_name>.paas.cloud-temple.com`
   - `https://nginx-tls-poc-Helmfile.apps-ocp<cluster_number>-<cluster_name>.paas.cloud-temple.com`.

## Validation Criteria

1. Both applications run successfully without errors.
2. Pods use UIDs > 30000, adhering to rootless constraints.
3. No custom CRDs are deployed.
4. Services are accessible and operational.