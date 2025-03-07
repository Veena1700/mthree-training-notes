# **Detailed Explanation **

## **Overview**
`k8s-master-app` is a **Kubernetes deployment** that automates setting up a Flask-based web application inside a **Minikube Kubernetes cluster**. It creates **namespaces, ConfigMaps, Secrets, Deployments, Services, and Autoscaling** while handling **WSL2 compatibility issues**

---

## **Step 1: Setting Up the Project Directory**
The script first creates a structured directory for the project:

```sh
PROJECT_DIR=~/k8s-master-app
mkdir -p ${PROJECT_DIR}/{app,k8s/{base,volumes,networking,config,monitoring},scripts,data,config,logs}
```

 **What this does:**
- Creates a **root directory** `~/k8s-master-app`.
- Organizes files into subdirectories:
  - `app/` → Contains the **Flask application**.
  - `k8s/` → Stores **Kubernetes YAML files**.
  - `scripts/` → Contains **deployment and cleanup scripts**.
  - `data/` → Stores **data files**.
  - `config/` → Stores **configuration files**.
  - `logs/` → Stores **application logs**.

This ensures **better organization** of the project files.

---

## **Step 2: Creating the Flask Application**

The script generates a **Flask application** inside the `app/` directory:

```sh
cat > ${PROJECT_DIR}/app/app.py << 'EOL'
```

 **What this does:**
- Uses **Flask** to create an API-based web app.
- Reads environment variables from **ConfigMaps and Secrets**.
- Mounts **volumes** for reading and writing files.
- Provides **API endpoints** for:
  - `/` → Displays system information.
  - `/api/health` → Health check for Kubernetes.
  - `/api/metrics` → System resource usage.

The app **logs activity**, simulates **CPU usage**, and integrates with **Kubernetes monitoring**.

---

## **Step 3: Creating the Dockerfile**

The script generates a `Dockerfile` to containerize the Flask app:

```sh
cat > ${PROJECT_DIR}/app/Dockerfile << 'EOL'
```

 **What this does:**
- Uses **Python 3.9** as the base image.
- Copies `app.py` and `requirements.txt` into the container.
- Installs Flask dependencies.
- Exposes **port 5000**.
- Runs the application inside the container.

Once built, this image will be deployed inside **Kubernetes pods**.

---

## **Step 4: Creating Kubernetes YAML Files**
The script generates **all necessary Kubernetes configurations** for deployment.

### **4.1 Namespace**
```sh
cat > ${PROJECT_DIR}/k8s/base/namespace.yaml << 'EOL'
```
- Creates a separate **namespace (`k8s-demo`)** for the application.

### **4.2 ConfigMap**
```sh
cat > ${PROJECT_DIR}/k8s/config/configmap.yaml << 'EOL'
```
- Stores **non-sensitive configuration data** (e.g., app name, version, environment variables).

### **4.3 Secret**
```sh
cat > ${PROJECT_DIR}/k8s/config/secret.yaml << 'EOL'
```
- Stores **sensitive data** (e.g., API keys, passwords) using **base64 encoding**.

### **4.4 Deployment**
```sh
cat > ${PROJECT_DIR}/k8s/base/deployment.yaml << 'EOL'
```
- Defines how Kubernetes **manages Flask application pods**.
- Uses `emptyDir` volumes for **WSL2 compatibility**.
- Sets up **Liveness and Readiness Probes** to check pod health.

### **4.5 Service**
```sh
cat > ${PROJECT_DIR}/k8s/networking/service.yaml << 'EOL'
```
- Exposes the application to external traffic using **NodePort**.

### **4.6 Autoscaling (HPA)**
```sh
cat > ${PROJECT_DIR}/k8s/monitoring/hpa.yaml << 'EOL'
```
- Defines a **Horizontal Pod Autoscaler** that scales pods based on **CPU/memory usage**.

---

## **Step 5: Deploying the Application**
The script provides a deployment script `deploy.sh` to automate the process.

### **5.1 Checking Prerequisites**
```sh
command_exists() { command -v "$1" &> /dev/null; }
```
- Ensures **Minikube, kubectl, and Docker** are installed before proceeding.

### **5.2 Starting Minikube**
```sh
minikube start --cpus=2 --memory=4096 --disk-size=20g
```
- Starts Minikube with **2 CPUs, 4GB RAM, and 20GB disk**.

### **5.3 Enabling Addons**
```sh
minikube addons enable dashboard
```
- Enables the **Minikube Dashboard** for monitoring resources.

### **5.4 Building the Docker Image**
```sh
docker build -t k8s-master-app:latest .
```
- Builds the **Docker image** inside Minikube.

### **5.5 Deploying Kubernetes Resources**
```sh
kubectl apply -f k8s/base/namespace.yaml
kubectl apply -f k8s/config/configmap.yaml
kubectl apply -f k8s/config/secret.yaml
kubectl apply -f k8s/base/deployment.yaml
kubectl apply -f k8s/networking/service.yaml
kubectl apply -f k8s/monitoring/hpa.yaml
```
- Deploys all Kubernetes **manifests**.

### **5.6 Checking Deployment Status**
```sh
kubectl -n k8s-demo rollout status deployment/k8s-master-app --timeout=180s
```
- Waits for pods to become **ready**.

### **5.7 Port Forwarding**
```sh
kubectl -n k8s-demo port-forward svc/k8s-master-app 8080:80 &
```
- Exposes the application on **http://localhost:8080**.

---

## **Step 6: Cleaning Up Resources**
The script includes `cleanup.sh` to remove all resources:

```sh
kubectl delete namespace k8s-demo
```
- Deletes the entire **namespace and all associated resources**.

```sh
docker rmi k8s-master-app:latest
```
- Removes the **Docker image** to free up space.

---

## **Step 7: Testing the Application**
The script provides `test-app.sh` for verification:

```sh
kubectl get pods -n k8s-demo
kubectl logs -l app=k8s-master -n k8s-demo
curl -s http://localhost:8080/api/health
```
- Checks pod status, logs, and **API health**.

---
