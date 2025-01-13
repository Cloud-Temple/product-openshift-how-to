# Deployment with ArgoCD and JMeter Testing

## Introduction :

This repository includes:

1. **MyShop Folder**: A folder ready to be deployed with ArgoCD to manage your application deployment.
**Adapted Google Microservices Demo**:  
   The application deployed in this setup is based on the [Google Cloud Platform Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo/tree/main).  
   It has been adjusted with a custom `securityContext` to ensure compatibility with our SNC offering.

2. **JMeter Dockerfile**: A pre-configured Dockerfile and test scenarios to perform load testing (`montée en charge`) on your application.

Use this setup to streamline deployment, test your application's performance, and demonstrate its deployment capabilities.

## Deploy the Application with ArgoCD

1. **Create the project**: `demoargo` in OpenShift.
2. Retrieve the `MyShop` folder from this repository, upload it to a repository in your GitHub account, and edit the `routes.yaml` file to match your configuration (replace `{your-id}` with your specific values).
4. **Go to GitOps**:
   - **Add your repository** in ArgoCD.
   - **Create a new application** (use the shortcut in the OpenShift GUI to open ArgoCD).
   - **Application Name**: `googlemyshop`.
   - **Project Name**: `default`.
   - **Enable automatic synchronization**, with the options:
     - **Prune**: Automatically remove resources not in the Git repository.
     - **Self Heal**: Automatically restore resources to match the repository.
   - **Repository URL**: The GitHub repository you created above.
   - **Path**: `MyShop`.
   - **Destination Namespace**: `demoargo`.
5. **Wait for synchronization** and verify the application in the OpenShift portal.


## Test with JMeter on Your Computer (using Docker Desktop)

**Prerequisite**
You need Docker Desktop on your computer

**Description**:
Apache JMeter is an open-source tool written in Java, designed for performance and load testing of various applications. While initially created for web application testing, it can also test APIs, databases, and more. 

This guide explains how to deploy JMeter using Docker, execute a performance test scenario, and analyze the results. You'll also learn how to modify parameters to push the site to its performance limits.

The `.jmx` file used in this test was generated using the BlazeMeter Chrome plugin, a tool that integrates with JMeter to create test scenarios. After generating the file, it was edited to include variables for simulating tests effectively.

1. **Edit the JMX File**:  
   Open the `jmeter/scenario/shop.jmx` file and edit line 63 to replace `{your-id}` with your specific value.

2. **Modify Test Parameters**:  
   Adjust the parameters in the `jmeter/config` file to suit your test scenario:
   - `NB_USERS=50` (Number of simulated users)
   - `DURATION=120` (Test duration in seconds)
   - `RAMPUP=10` (Time in seconds to ramp up users)

3. **Prepare a Directory for Docker**:  
   On your computer, create a folder at `c:\docker`.

4. **Run the JMeter Simulation**:  
   Use the following commands to build and run the JMeter Docker container:
   ```bash
   docker build -t jmeter:v1 .
   docker run --rm -ti --name test-jmeter -v /c/docker/demoargo:/opt/jmeter/shop/report-shop jmeter:v1 /bin/bash
   ```
5. **View the results on the graphs in OpenShift**

6. **Retrieve Jmeter Test Results**, after the test completes, the results will be available in the c:\docker\demoargo directory on your computer.