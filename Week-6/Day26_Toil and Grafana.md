## What is Toil?
Toil refers to **manual, repetitive, and automatable work** that does not add long-term value.  
In DevOps and Site Reliability Engineering (SRE), toil can slow down productivity and cause operational inefficiencies.

## Examples of Toil  
1. **Manual Log Analysis**  
   - Engineers manually search logs to diagnose errors instead of using automated log aggregation tools like **Loki**.  

2. **Repetitive Deployment Tasks**  
   - Deploying applications manually every time a change is made, instead of using CI/CD pipelines like **Jenkins** or **GitHub Actions**.  

3. **Handling Alerts Manually**  
   - Engineers responding to system alerts **without automated alerting** and escalation workflows in **Prometheus + Grafana**.  

Reducing toil **improves efficiency**, **reduces burnout**, and **enhances system reliability**.  
By leveraging automation, monitoring, and structured workflows, teams can focus on **high-value engineering tasks** instead of repetitive work.

# Kubernetes Monitoring with Grafana, Prometheus, and Loki

## 1. What is Grafana?
Grafana is an open-source **visualization tool** that creates dashboards for monitoring data. It supports multiple data sources, including **Prometheus and Loki**.

### Why do we need Grafana?
- **Custom Dashboards**: Provides real-time monitoring of applications.
- **Supports Multiple Data Sources**: Works with Prometheus, Loki, MySQL, and more.
- **Alerting & Notifications**: Helps detect issues with logs and metrics.

## 2. What is Prometheus?
Prometheus is an **open-source monitoring system** that collects and stores **time-series data**.

### Why do we need Prometheus?
- **Efficient Metric Collection**: Pulls data from services and stores it.
- **Powerful Querying with PromQL**: Enables complex data analysis.
- **Integration with Grafana**: Provides visualization of system metrics.

## 3. What is Loki?
Loki is a **log aggregation system** that efficiently indexes and searches logs.

### Why do we need Loki?
- **Centralized Log Management**: Stores logs from multiple sources.
- **Optimized for Kubernetes**: Easily integrates with Promtail.
- **Works with Grafana**: Enables log visualization.

## 4. Grafana vs. Loki vs. Prometheus

| Feature    | Grafana | Prometheus | Loki |
|------------|---------|------------|------|
| Purpose    | Dashboards & Visualization | Metrics Collection | Log Aggregation |
| Data Type  | Time-Series & Logs | Time-Series Metrics | Logs |
| Query Language | Grafana Query | PromQL | LogQL |
| Alerting   | Yes | Yes | No |
| Storage    | External Data Sources | Time-Series Database | Log Storage |

## 6. Detailed Breakdown of `simple-grafana-monitoring.sh`

### **1. Setup and Minikube Initialization**

```bash
#!/bin/bash

# Exit on error
set -e
```

- `set -e` ensures the script stops execution if any command fails.

```bash
read -p "Do you want to reset Minikube? (y/n): " reset_choice
if [[ "$reset_choice" == "y" ]]; then
  minikube stop || true
  minikube delete || true
  minikube start --driver=docker --cpus=2 --memory=2200
else
  echo "Using existing Minikube cluster..."
fi
```

- Asks if Minikube should be reset.
- Starts a fresh Minikube cluster if needed.

### **2. Verify Minikube Status**

```bash
minikube status
kubectl get nodes
```

- Ensures Minikube is running.

### **3. Deploying a Sample Logging App**

```bash
kubectl create namespace sample-app 2>/dev/null || true
```

- Creates the **`sample-app` namespace** (ignores errors if it exists).

```bash
cat <<EOF > sample-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-logger
  namespace: sample-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sample-logger
  template:
    metadata:
      labels:
        app: sample-logger
    spec:
      containers:
      - name: logger
        image: busybox
        command: ["/bin/sh", "-c"]
        args:
        - >
          while true; do
            echo "[INFO] Log entry at \$(date)";
            sleep 3;
            echo "[DEBUG] Processing data...";
            sleep 2;
            if [ \$((RANDOM % 10)) -eq 0 ]; then
              echo "[ERROR] Sample error occurred!";
            fi;
            sleep 1;
          done
EOF

kubectl apply -f sample-app.yaml
```

- Deploys a **sample app that generates logs**.

### **4. Installing Prometheus**

```bash
helm install prometheus prometheus-community/prometheus --namespace monitoring
kubectl wait --for=condition=ready pod --selector="app.kubernetes.io/name=prometheus" -n monitoring --timeout=120s
```

- Installs Prometheus and waits for it to be **ready**.

### **5. Installing Loki for Log Aggregation**

```bash
helm install loki grafana/loki-stack --namespace monitoring --set grafana.enabled=false
```

- Installs Loki **without Grafana**.

### **6. Installing and Configuring Grafana**

```bash
helm install grafana grafana/grafana --namespace monitoring --set adminPassword=admin
kubectl wait --for=condition=ready pod --selector="app.kubernetes.io/name=grafana" -n monitoring --timeout=180s
kubectl port-forward svc/grafana -n monitoring 3000:80 &
```

- Installs Grafana and **exposes it on port 3000**.

### **7. Creating a Custom Dashboard**

```bash
cat <<EOF > dashboard.json
{
  "dashboard": {
    "title": "Application Logs",
    "panels": [
      {
        "title": "Sample App Logs",
        "type": "logs",
        "datasource": "Loki",
        "targets": [
          {
            "expr": "{namespace=\"sample-app\", app=\"sample-logger\"}"
          }
        ]
      }
    ]
  },
  "overwrite": true
}
EOF

curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Basic $(echo -n 'admin:admin' | base64)" -d @dashboard.json http://localhost:3000/api/dashboards/db
```

- Creates a **custom dashboard** for **logs from Loki**.

### **8. Final Steps**

```bash
echo "Grafana: http://localhost:3000"
echo "Username: admin"
echo "Password: admin"
wait $PORT_FORWARD_PID
```

- Provides **login details**.
- Keeps the script running for **port-forwarding**.

---

## **7. Conclusion**
This script fully automates **Kubernetes monitoring** using:
- **Prometheus** for **metrics collection**.
- **Loki** for **log aggregation**.
- **Grafana** for **visualization**.

After running the script, visit `http://localhost:3000` to access **Grafana dashboards**.

# 8. Setting Up a Grafana Dashboard

  ## Step 1: Access Grafana
  1. Ensure Grafana is running:
     ```bash
     kubectl port-forward svc/grafana -n monitoring 3000:80
     ```
  2. Open **http://localhost:3000** in your browser.  
  3. Log in with:  
     - **Username:** admin  
     - **Password:** admin  
  
  ## Step 2: Create a New Dashboard  
  1. Click the **"+" icon** on the left sidebar.  
  2. Select **"Dashboard"** → **"Add a new panel"**.  
  
  ## Step 3: Configure a Logs Panel  
  1. Select **"Loki"** as the data source.  
  2. Enter the query:  
     ```
     {namespace="sample-app"}
     ```  
  3. Choose **"Logs"** visualization.  
  4. Set panel title: **"Application Logs"** → Enable **"Show time"**.  
  5. Click **"Apply"** to save.

<p align="center">
  <img src="../images/day-26/screenshot4.jpg" width="75%" alt="Image">
</p>
  
  ## Step 4: Add an Error Logs Panel  
  1. Click **"Add panel"** → **Select Loki**.  
  2. Use this query to filter error logs:  
     ```
     {namespace="sample-app"} |= "ERROR"
     ```  
  3. Configure:  
     - **Title:** "Error Logs"  
     - Enable **"Show labels"**  
  4. Click **"Apply"**.

<p align="center">
  <img src="../images/day-26/screenshot3.jpg" width="75%" alt="Image">
</p>
  
  ## Step 5: Add a CPU Usage Metrics Panel  
  1. Click **"Add panel"** → **Select Prometheus**.  
  2. Enter the query:  
     ```
     sum(rate(container_cpu_usage_seconds_total{namespace="sample-app"}[5m])) by (pod)
     ```  
  3. Select **"Time series"** visualization.  
  4. Set title: **"CPU Usage by Pod"** → Configure legend & unit as **percent**.  
  5. Click **"Apply"**.

<p align="center">
  <img src="../images/day-26/screenshot2.jpg" width="75%" alt="Image">
</p>
  
  ## Step 6: Add a Log Volume Panel  
  1. Click **"Add panel"** → **Select Loki**.  
  2. Change query type to **Instant**.  
  3. Enter:  
     ```
     sum(count_over_time({namespace="sample-app"}[5m])) by (pod_name)
     ```  
  4. Choose **"Time series"** → Set title to **"Log Volume by Pod"**.  
  5. Click **"Apply"**.

<p align="center">
  <img src="../images/day-26/screenshot1.jpg" width="75%" alt="Image">
</p>
  
  ## Step 7: Arrange and Resize Panels  
  1. Drag panels to reposition.  
  2. Resize by dragging panel corners.  
  3. Organize metrics logically.

<p align="center">
  <img src="../images/day-26/screenshot5.jpg" width="75%" alt="Image">
</p>
  
  ## Step 8: Configure Dashboard Settings  
  1. Click the **gear icon** → **General Settings**.  
  2. Name: **"Kubernetes Application Monitoring"**.  
  3. Set time range: **"Last 15 minutes"** → Refresh every **5s**.  
  4. Click **"Save"**.  
  
  ## Step 9: Save Your Dashboard  
  1. Click **Save** → Enter a name → Add a description (optional).  
  2. Click **"Save"**.  
  
  ## Step 10: Enable Auto Refresh  
  1. Set **refresh interval** (top-right) to **5s** for real-time updates.  
  
  Your **Grafana Dashboard is now ready!**
  It will update logs and metrics dynamically for Kubernetes monitoring.  
