# How to deploy vm into kubevirt

## General :
[https://github.com/kubevirt/common-templates/tree/master](https://github.com/kubevirt/common-templates/tree/master) you can use this repo if templates are missing in the catalog. Generally, the catalog is sufficient.

## Fedora VM

- Step 1: Create a Fedora Virtual Machine
  1. Go to the **Administrator** view and select **Virtualization**.  
  2. Navigate to **Catalog**.  
  3. Create a new VM with the following parameters:  
     - **Operating System**: Fedora  
     - **Instance Type**: U Series with **2 CPU and 8 GB RAM**  
     - **VM Name**: `fedora-nginx`  
  4. Add your **SSH public key** using `mysshkey`
  5. Click **Create** to launch the VM.

- Step 2: OpenShift CLI Setup
    While the VM is being created, configure your CLI access:
    - Set the project:  
    ```bash
    oc project demokubevirt
    ```
    - Log in to the OpenShift API:  
    ```bash
    oc login api-ocp01-{your-id}.paas.cloud-temple.com --web
    ```

- Step 3: Access the Fedora VM 
  1. Apply the SSH port forwarding manifest:  
    ```bash
     oc apply -f ssh-port-forward.yaml
    ```
  2. Forward port **2222** locally for SSH access:  
    ```bash
     oc port-forward svc/fedora-service-ssh 2222:22
    ```
  3. Open another terminal and connect to the VM:  
    ```bash
     ssh cloud-user@127.0.0.1 -p 2222 -o StrictHostKeyChecking=no
    ```

- Step 4: Deploy NGINX on Fedora VM
  1. Create the `nginx-expose.yaml` manifest.  
  2. Log into the Fedora VM via SSH and install NGINX:
     - Update the system:  
    ```bash
       sudo dnf update -y  
    ```
     - Install NGINX:  
    ```bash
       sudo dnf install nginx -y
    ```
     - Start NGINX:  
    ```bash
       sudo systemctl start nginx
    ```
     - Enable NGINX to start on boot: 
    ```bash 
       sudo systemctl enable nginx
    ```
     - Check NGINX status:  
    ```bash
       sudo systemctl status nginx 
    ```
  3. Confirm that NGINX is running successfully.


- Step 5: Access the NGINX Web Page
  1. Open the NGINX web page in a browser:  
     `https://nginx-fedora.apps-ocp01-{your-id}.paas.cloud-temple.com`

  2. Confirm that the NGINX welcome page is displayed.


## Windows Custom Template

- Step 1 : Create a template
  1. Create a VM in VMware Workstation with the following components:  
    - **Drivers**: install virtio / sata / e1000e / uefi  
    - Perform a **Sysprep** and install *Virtioand export the image in **OVF** format.  
  2. Convert the **VMDK** image to **qcow2** format using the `qemu-img` command:  
    ```bash
    qemu-img convert -f vmdk -O qcow2 WindowsServer2022-OC-disk1.vmdk output.qcow2
    ```
  3. Upload the image to an **Azure Blob** for examples. Get the Sas Key


- Step 2: Deploy the Image in KubeVirt
  1. Go to the **catalog** in OpenShift and create a custom template for **Windows Server 2022**:  
    - **Configuration**:  
      - **2 CPU**  
      - **8 GB RAM**  
      - **Volume**: 100 GB  
      - **VM Name**: `windows-iis`  
  2. In advanced settings, configure the **storage** to use **virtio** (drivers are already installed).  
  3. For the disk source : use **URL (create PVC)** and paste the SAS Key you get on the blob.
  4. Monitor the progress in the **Diagnostics** tab.  

- Step 3: Deploy the Image in KubeVirt
  - Perform the initial configuration (administrator password, keyboard, etc.)  
  - Install **IIS** from the console.

- Step 4: Configure RDP Access and Expose IIS
  1. Apply the YAML manifests:  
    ```bash
    oc project rdp-port-forward.yaml
    oc project iis-expose.yaml 
    ```
  2. Configure port forwarding to access the VM via **RDP**:  
    ```bash
    oc project demokubevirt  
    oc port-forward svc/windows-service-rdp 2222:3389  
    ```
  3. Open a new terminal and connect with RDP client : 
    ```bash
    mstsc -v 127.0.0.1:2222
    ```

- Step 5: Verify the IIS Web Page
  1.  Access the IIS page from your browser:  
  `https://iis-windows.apps-ocp01-{your-id}.paas.cloud-temple.com`
