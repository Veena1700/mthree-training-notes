# Kubernetes Commands

---

## **1️⃣ Namespace Management**

### **View Current Namespace**
```sh
kubectl config view --minify | grep namespace
```
- Displays the **active namespace** in the current Kubernetes context.

### **Create a Namespace**
```sh
kubectl apply -f k8s/base/namespace.yaml
```
- Creates a namespace **k8s-demo** from a YAML file.

### **List All Namespaces**
```sh
kubectl get namespaces
```
- Displays all namespaces in the Kubernetes cluster.

### **Delete a Namespace**
```sh
kubectl delete namespace k8s-demo
```
- Deletes the **k8s-demo** namespace and all resources within it.

---

## **2️⃣ Deployment Commands**

### **Apply a Deployment**
```sh
kubectl apply -f k8s/base/deployment.yaml
```
- Deploys the application using the **Deployment YAML**.
- Ensures the desired number of **pod replicas** are running.

### **Check Deployment Status**
```sh
kubectl -n k8s-demo rollout status deployment/k8s-master-app --timeout=180s
```
- Waits for the deployment to **fully roll out** (up to 180s timeout).

### **List All Deployments**
```sh
kubectl get deployments -n k8s-demo
```
- Displays all **Deployments** running in the namespace.

### **Describe a Deployment**
```sh
kubectl describe deployment k8s-master-app -n k8s-demo
```
- Shows detailed **configuration and status** of the deployment.

### **Delete a Deployment**
```sh
kubectl delete -f k8s/base/deployment.yaml
```
- Deletes the deployment while **keeping other resources intact**.

---

## **3️⃣ Service Management**

### **Apply a Service (NodePort)**
```sh
kubectl apply -f k8s/networking/service.yaml
```
- Creates a **Service** to expose the application.
- Uses **NodePort** to make it accessible externally.

### **List Services**
```sh
kubectl get services -n k8s-demo
```
- Displays all **Services** running in the namespace.

### **Describe a Service**
```sh
kubectl describe service k8s-master-app -n k8s-demo
```
- Provides details about the service, including **ports and endpoints**.

### **Delete a Service**
```sh
kubectl delete -f k8s/networking/service.yaml
```
- Removes the **Service** but keeps the running pods.

---

## **4️⃣ ConfigMaps & Secrets**

### **Apply a ConfigMap**
```sh
kubectl apply -f k8s/config/configmap.yaml
```
- Stores **non-sensitive** environment variables in Kubernetes.

### **View ConfigMaps**
```sh
kubectl get configmaps -n k8s-demo
```
- Lists all ConfigMaps in the namespace.

### **Apply a Secret**
```sh
kubectl apply -f k8s/config/secret.yaml
```
- Stores **sensitive** data (e.g., passwords, API keys) in Kubernetes.

### **View Secrets**
```sh
kubectl get secrets -n k8s-demo
```
- Lists all Secrets in the namespace.

---

## **5️⃣ Pod Management**

### **View Running Pods**
```sh
kubectl get pods -n k8s-demo
```
- Displays all **pods** running in the namespace.

### **Describe a Pod**
```sh
kubectl describe pod <pod-name> -n k8s-demo
```
- Shows detailed information about a specific **pod**.

### **View Logs from a Pod**
```sh
kubectl logs -n k8s-demo -l app=k8s-master
```
- Retrieves logs for **all pods** labeled `app=k8s-master`.

### **Access a Running Pod (Bash Shell)**
```sh
kubectl exec -it <pod-name> -n k8s-demo -- /bin/bash
```
- Opens a **shell session** inside a running pod.

### **Delete a Pod**
```sh
kubectl delete pod <pod-name> -n k8s-demo
```
- Deletes a specific pod (it will restart if managed by a Deployment).

---

## **6️⃣ Scaling & Auto-Scaling**

### **Apply Horizontal Pod Autoscaler (HPA)**
```sh
kubectl apply -f k8s/monitoring/hpa.yaml
```
- Enables **auto-scaling** based on CPU and memory usage.

### **View HPA Status**
```sh
kubectl get hpa -n k8s-demo
```
- Displays **scaling rules and current pod count**.

### **Manually Scale the Deployment**
```sh
kubectl scale deployment k8s-master-app --replicas=3 -n k8s-demo
```
- Sets the number of running pods to **3**.

---

## **7️⃣ Port Forwarding & Exposing Services**

### **Port Forwarding to Localhost**
```sh
kubectl -n k8s-demo port-forward svc/k8s-master-app 8080:80
```
- Maps **localhost:8080** to the service’s port **80**.

### **Find Minikube IP**
```sh
minikube ip
```
- Retrieves the IP of the Minikube cluster.

### **Access App via NodePort**
```sh
http://<minikube-ip>:30080
```
- Open the app in a **browser** using Minikube’s IP and **NodePort 30080**.

### **Open the App via Minikube Service**
```sh
minikube service k8s-master-app -n k8s-demo
```
- Opens the **Kubernetes service** in the browser.

---

## **8️⃣ Cleaning Up Resources**

### **Delete All Resources in Namespace**
```sh
kubectl delete namespace k8s-demo
```
- Completely removes the namespace and **all deployed resources**.

### **Manually Delete Resources**
```sh
kubectl delete -f k8s/monitoring/hpa.yaml
kubectl delete -f k8s/networking/service.yaml
kubectl delete -f k8s/base/deployment.yaml
kubectl delete -f k8s/config/secret.yaml
kubectl delete -f k8s/config/configmap.yaml
kubectl delete -f k8s/base/namespace.yaml
```
- Deletes **each resource separately**.

### **Remove Docker Image from Minikube**
```sh
docker rmi k8s-master-app:latest
```
- Deletes the **Docker image** to free up space.

---
