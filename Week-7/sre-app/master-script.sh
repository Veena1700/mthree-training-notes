#!/bin/bash

# set -e

# echo "========== SRE Application Setup Master Script =========="
# echo "This script will set up the complete SRE environment with WSL, Minikube, Prometheus, Grafana, Flask API, and Angular UI"

# # Create directories for the project
# PROJECT_ROOT="$HOME/sre-app"
# mkdir -p "$PROJECT_ROOT"
# cd "$PROJECT_ROOT"

# # Create directories for different components
# mkdir -p wsl-setup
# mkdir -p k8s
# mkdir -p flask-api
# mkdir -p angular-ui
# mkdir -p prometheus
# mkdir -p grafana

# echo "Creating WSL and Minikube setup script..."
# cat > wsl-setup/setup-wsl-minikube.sh << 'EOF'
# # Script content goes here - copy from WSL and Minikube Setup Script artifact
# #!/bin/bash

# set -e

# echo "========== WSL & Minikube Setup Script =========="
# echo "This script will install and configure WSL, Docker, and Minikube"

# # Check if running on Windows
# if [[ "$(uname -r)" != *Microsoft* ]] && [[ "$(uname -r)" != *microsoft* ]]; then
#   echo "This script must be run on Windows with WSL support."
#   echo "Please run from Windows PowerShell with Admin privileges:"
#   echo "  1. Open PowerShell as Administrator"
#   echo "  2. Run: wsl --install"
#   echo "  3. Restart your computer"
#   echo "  4. After restart, the WSL installation will complete"
#   echo "  5. Then run this script again within the WSL environment"
#   exit 1
# fi

# # Update & upgrade packages
# echo "Updating and upgrading packages..."
# sudo apt update && sudo apt upgrade -y

# # Install required packages
# echo "Installing required packages..."
# sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# # Install Docker
# echo "Installing Docker..."
# if ! command -v docker &> /dev/null; then
#   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#   echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
#   sudo apt update
#   sudo apt install -y docker-ce docker-ce-cli containerd.io
#   sudo usermod -aG docker $USER
#   echo "Docker installed successfully. You may need to log out and back in for group changes to take effect."
# else
#   echo "Docker is already installed."
# fi

# # Install kubectl
# echo "Installing kubectl..."
# if ! command -v kubectl &> /dev/null; then
#   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
#   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#   rm kubectl
#   echo "kubectl installed successfully."
# else
#   echo "kubectl is already installed."
# fi

# # Install Minikube
# echo "Installing Minikube..."
# if ! command -v minikube &> /dev/null; then
#   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
#   sudo install minikube-linux-amd64 /usr/local/bin/minikube
#   rm minikube-linux-amd64
#   echo "Minikube installed successfully."
# else
#   echo "Minikube is already installed."
# fi

# # Start Minikube
# echo "Starting Minikube with limited resources to save space..."
# minikube start --driver=docker --cpus=2 --memory=2048 --disk-size=10g

# # Enable required addons
# echo "Enabling Minikube addons..."
# minikube addons enable ingress
# minikube addons enable metrics-server
# minikube addons enable dashboard

# # Create a namespace for our applications
# echo "Creating kubernetes namespace for SRE applications..."
# kubectl create namespace sre-monitoring --dry-run=client -o yaml | kubectl apply -f -

# echo "==========================================="
# echo "WSL and Minikube setup completed successfully!"
# echo "Minikube status:"
# minikube status
# echo "==========================================="
# EOF
# chmod +x wsl-setup/setup-wsl-minikube.sh
# ./wsl-setup/setup-wsl-minikube.sh

# echo "Creating Prometheus setup script..."
# cat > prometheus/setup-prometheus.sh << 'EOF'
# # Script content goes here - copy from Prometheus Setup Script artifact
# #!/bin/bash

# set -e

# echo "========== Prometheus Setup Script =========="
# echo "This script will install and configure Prometheus in Minikube"

# # Check if minikube is running
# if ! minikube status &> /dev/null; then
#   echo "Minikube is not running. Please start minikube first."
#   exit 1
# fi

# # Create directory for Prometheus configuration
# mkdir -p prometheus-config

# # Create prometheus.yml configuration file
# cat > prometheus-config/prometheus.yml << EOF
# global:
#   scrape_interval: 15s
#   evaluation_interval: 15s

# alerting:
#   alertmanagers:
#     - static_configs:
#         - targets:
#           # - alertmanager:9093

# rule_files:
#   # - "first_rules.yml"
#   # - "second_rules.yml"

# scrape_configs:
#   - job_name: "prometheus"
#     static_configs:
#       - targets: ["localhost:9090"]

#   - job_name: "kubernetes-apiservers"
#     kubernetes_sd_configs:
#       - role: endpoints
#     scheme: https
#     tls_config:
#       ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
#       insecure_skip_verify: true
#     bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
#     relabel_configs:
#       - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
#         action: keep
#         regex: default;kubernetes;https

#   - job_name: "kubernetes-nodes"
#     scheme: https
#     tls_config:
#       ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
#       insecure_skip_verify: true
#     bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
#     kubernetes_sd_configs:
#       - role: node
#     relabel_configs:
#       - action: labelmap
#         regex: __meta_kubernetes_node_label_(.+)
#       - target_label: __address__
#         replacement: kubernetes.default.svc:443
#       - source_labels: [__meta_kubernetes_node_name]
#         regex: (.+)
#         target_label: __metrics_path__
#         replacement: /api/v1/nodes/$1/proxy/metrics

#   - job_name: "kubernetes-pods"
#     kubernetes_sd_configs:
#       - role: pod
#     relabel_configs:
#       - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
#         action: keep
#         regex: true
#       - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
#         action: replace
#         target_label: __metrics_path__
#         regex: (.+)
#       - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
#         action: replace
#         regex: ([^:]+)(?::\d+)?;(\d+)
#         replacement: "\$1:\$2"
#         target_label: __address__
#       - action: labelmap
#         regex: __meta_kubernetes_pod_label_(.+)
#       - source_labels: [__meta_kubernetes_namespace]
#         action: replace
#         target_label: kubernetes_namespace
#       - source_labels: [__meta_kubernetes_pod_name]
#         action: replace
#         target_label: kubernetes_pod_name

#   - job_name: "flask-app"
#     static_configs:
#       - targets: ["flask-api-service:5000"]
# EOF

# # Create Kubernetes manifests directory
# mkdir -p k8s-manifests
# NAMESPACE="sre-monitoring"

# # Create Prometheus ConfigMap
# cat > k8s-manifests/prometheus-configmap.yaml << EOF
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: prometheus-config
#   namespace: ${NAMESPACE}
# data:
#   prometheus.yml: |
# $(sed 's/^/    /' prometheus-config/prometheus.yml)
# EOF

# # Create Prometheus Deployment
# cat > k8s-manifests/prometheus-deployment.yaml << EOF
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: prometheus
#   namespace: ${NAMESPACE}
#   labels:
#     app: prometheus
# spec:
#   replicas: 1
#   selector:
#     matchLabels:
#       app: prometheus
#   template:
#     metadata:
#       labels:
#         app: prometheus
#     spec:
#       containers:
#       - name: prometheus
#         image: prom/prometheus:v2.42.0
#         args:
#           - "--config.file=/etc/prometheus/prometheus.yml"
#           - "--storage.tsdb.path=/prometheus"
#           - "--storage.tsdb.retention.time=15d"
#           - "--web.enable-lifecycle"
#         ports:
#         - containerPort: 9090
#         volumeMounts:
#         - name: prometheus-config
#           mountPath: /etc/prometheus
#         - name: prometheus-storage
#           mountPath: /prometheus
#         resources:
#           requests:
#             cpu: 200m
#             memory: 512Mi
#           limits:
#             cpu: 500m
#             memory: 1Gi
#       volumes:
#       - name: prometheus-config
#         configMap:
#           name: prometheus-config
#       - name: prometheus-storage
#         emptyDir: {}
# EOF

# # Create Prometheus Service
# cat > k8s-manifests/prometheus-service.yaml << EOF
# apiVersion: v1
# kind: Service
# metadata:
#   name: prometheus
#   namespace: ${NAMESPACE}
#   labels:
#     app: prometheus
# spec:
#   ports:
#   - port: 9090
#     targetPort: 9090
#     name: web
#   selector:
#     app: prometheus
#   type: ClusterIP
# EOF

# # Apply Kubernetes manifests
# echo "Applying Prometheus Kubernetes manifests..."
# kubectl apply -f k8s-manifests/prometheus-configmap.yaml
# kubectl apply -f k8s-manifests/prometheus-deployment.yaml
# kubectl apply -f k8s-manifests/prometheus-service.yaml

# # Wait for Prometheus deployment to be ready
# echo "Waiting for Prometheus deployment to be ready..."
# kubectl -n ${NAMESPACE} rollout status deployment/prometheus

# # Port-forward for local access (will run in background)
# echo "Setting up port forwarding for Prometheus..."
# nohup kubectl -n ${NAMESPACE} port-forward svc/prometheus 9090:9090 > /dev/null 2>&1 &
# PROM_PORT_FORWARD_PID=$!

# echo "==========================================="
# echo "Prometheus has been successfully deployed!"
# echo "Access the Prometheus UI at: http://localhost:9090"
# echo "==========================================="
# echo "Note: Port forwarding is running in the background with PID: ${PROM_PORT_FORWARD_PID}"
# echo "To stop port forwarding: kill ${PROM_PORT_FORWARD_PID}"

# chmod +x prometheus/setup-prometheus.sh
# ./prometheus/setup-prometheus.sh

echo "Creating Grafana setup script..."
cat > grafana/setup-grafana.sh << 'EOF'
# Script content goes here - copy from Grafana Setup Script artifact
#!/bin/bash

set -e

echo "========== Grafana Setup Script =========="
echo "This script will install and configure Grafana in Minikube"

# Check if minikube is running
if ! minikube status &> /dev/null; then
  echo "Minikube is not running. Please start minikube first."
  exit 1
fi

# Create directory for Grafana configuration
mkdir -p grafana-config
NAMESPACE="sre-monitoring"

# Create Kubernetes manifests directory if not exists
mkdir -p k8s-manifests

# Create Grafana Deployment
cat > k8s-manifests/grafana-deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: ${NAMESPACE}
  labels:
    app: grafana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:9.5.2
        ports:
        - containerPort: 3000
          name: http
        env:
        - name: GF_SECURITY_ADMIN_USER
          value: admin
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: admin
        - name: GF_USERS_ALLOW_SIGN_UP
          value: "false"
        - name: GF_INSTALL_PLUGINS
          value: "grafana-piechart-panel"
        volumeMounts:
        - name: grafana-storage
          mountPath: /var/lib/grafana
        - name: grafana-datasources
          mountPath: /etc/grafana/provisioning/datasources
        - name: grafana-dashboards-provider
          mountPath: /etc/grafana/provisioning/dashboards
        - name: grafana-dashboards
          mountPath: /var/lib/grafana/dashboards
        resources:
          requests:
            cpu: 100m
            memory: 256Mi
          limits:
            cpu: 200m
            memory: 512Mi
      volumes:
      - name: grafana-storage
        emptyDir: {}
      - name: grafana-datasources
        configMap:
          name: grafana-datasources
      - name: grafana-dashboards-provider
        configMap:
          name: grafana-dashboards-provider
      - name: grafana-dashboards
        configMap:
          name: grafana-dashboards
EOF

# Create Grafana Service
cat > k8s-manifests/grafana-service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: ${NAMESPACE}
  labels:
    app: grafana
spec:
  ports:
  - port: 3000
    targetPort: 3000
    name: http
  selector:
    app: grafana
  type: ClusterIP
EOF

# Create Grafana datasources ConfigMap
mkdir -p grafana-config/datasources
cat > grafana-config/datasources/prometheus.yaml << EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false
EOF

cat > k8s-manifests/grafana-datasources-configmap.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-datasources
  namespace: ${NAMESPACE}
data:
  prometheus.yaml: |
$(sed 's/^/    /' grafana-config/datasources/prometheus.yaml)
EOF

# Create Grafana dashboards provider ConfigMap
mkdir -p grafana-config/dashboards
cat > grafana-config/dashboards/provider.yaml << EOF
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    updateIntervalSeconds: 30
    options:
      path: /var/lib/grafana/dashboards
EOF

cat > k8s-manifests/grafana-dashboards-provider-configmap.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboards-provider
  namespace: ${NAMESPACE}
data:
  provider.yaml: |
$(sed 's/^/    /' grafana-config/dashboards/provider.yaml)
EOF

# Create a basic dashboard with metrics
cat > grafana-config/dashboards/kubernetes-overview.json << EOF
{
  "annotations": {
    "list": []
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": null,
  "links": [],
  "panels": [
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 1,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(rate(container_cpu_usage_seconds_total{pod=~\"flask-api-.*|angular-ui-.*\"}[5m])) by (pod)",
          "interval": "",
          "legendFormat": "{{pod}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "CPU Usage by Pod",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 2,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "sum(container_memory_working_set_bytes{pod=~\"flask-api-.*|angular-ui-.*\"}) by (pod)",
          "interval": "",
          "legendFormat": "{{pod}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "Memory Usage by Pod",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "bytes",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 8
      },
      "hiddenSeries": false,
      "id": 3,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "rate(http_requests_total{handler=\"/api\"}[5m])",
          "interval": "",
          "legendFormat": "{{handler}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "API Request Rate",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "short",
          "label": "Requests/s",
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 12,
        "y": 8
      },
      "hiddenSeries": false,
      "id": 4,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "rate(http_request_duration_seconds_sum{handler=\"/api\"}[5m]) / rate(http_request_duration_seconds_count{handler=\"/api\"}[5m])",
          "interval": "",
          "legendFormat": "{{handler}}",
          "refId": "A"
        }
      ],
      "thresholds": [],
      "timeRegions": [],
      "title": "API Response Time",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "s",
          "label": "Response Time",
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    }
  ],
  "refresh": "10s",
  "schemaVersion": 27,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-1h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "SRE Application Dashboard",
  "uid": "sre-k8s-dashboard",
  "version": 1
}
EOF

cat > k8s-manifests/grafana-dashboards-configmap.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-dashboards
  namespace: ${NAMESPACE}
data:
  kubernetes-overview.json: |
$(sed 's/^/    /' grafana-config/dashboards/kubernetes-overview.json)
EOF

# Apply Kubernetes manifests
echo "Applying Grafana Kubernetes manifests..."
kubectl apply -f k8s-manifests/grafana-datasources-configmap.yaml
kubectl apply -f k8s-manifests/grafana-dashboards-provider-configmap.yaml
kubectl apply -f k8s-manifests/grafana-dashboards-configmap.yaml
kubectl apply -f k8s-manifests/grafana-deployment.yaml
kubectl apply -f k8s-manifests/grafana-service.yaml

# Wait for Grafana deployment to be ready
echo "Waiting for Grafana deployment to be ready..."
kubectl -n ${NAMESPACE} rollout status deployment/grafana

# Port-forward for local access (will run in background)
echo "Setting up port forwarding for Grafana..."
nohup kubectl -n ${NAMESPACE} port-forward svc/grafana 3000:3000 > /dev/null 2>&1 &
GRAFANA_PORT_FORWARD_PID=$!

echo "==========================================="
echo "Grafana has been successfully deployed!"
echo "Access Grafana UI at: http://localhost:3000"
echo "Default login credentials: admin/admin"
echo "==========================================="
echo ""
echo "Grafana Instructions:"
echo "1. After logging in with the default credentials (admin/admin), you'll be prompted to change the password."
echo "2. The Prometheus data source is already configured."
echo "3. A basic SRE dashboard has been pre-configured with key metrics."
echo "4. To create additional dashboards:"
echo "   - Click on '+ Create' in the left sidebar menu"
echo "   - Select 'Dashboard' to create a new dashboard"
echo "   - Click 'Add new panel' to add monitoring metrics"
echo "   - In the query panel, you can use PromQL to query metrics from Prometheus"
echo "5. For monitoring Angular and Flask applications:"
echo "   - Use metrics like 'http_requests_total' for request counts"
echo "   - 'http_request_duration_seconds' for response times"
echo "   - 'container_memory_usage_bytes' and 'container_cpu_usage_seconds_total' for resource usage"
echo "6. To set up alerts:"
echo "   - Go to Alerting in the left sidebar"
echo "   - Click 'Create Alert Rule' to set up new alerts"
echo "   - Configure alerts for response time thresholds, error rates, or resource usage"
echo ""
echo "Note: Port forwarding is running in the background with PID: ${GRAFANA_PORT_FORWARD_PID}"
echo "To stop port forwarding: kill ${GRAFANA_PORT_FORWARD_PID}"
EOF
chmod +x grafana/setup-grafana.sh
./grafana/setup-grafana.sh

echo "Creating Flask API files..."
cat > flask-api/app.py << 'EOF'
# Script content goes here - copy from Flask API Backend Application artifact
EOF

cat > flask-api/requirements.txt << 'EOF'
flask==2.3.2
flask-cors==4.0.0
prometheus-client==0.17.1
gunicorn==21.2.0
EOF

cat > flask-api/Dockerfile << 'EOF'
# Dockerfile for Flask API
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
EOF

echo "Creating Flask API Kubernetes configuration..."
mkdir -p k8s/flask-api
cat > k8s/flask-api/deployment.yaml << 'EOF'
# Kubernetes deployment content - copy from Flask API Dockerfile artifact
# Kubernetes deployment file
# contents below should be saved as flask-api-deployment.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-api
  namespace: sre-monitoring
  labels:
    app: flask-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-api
  template:
    metadata:
      labels:
        app: flask-api
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "5000"
        prometheus.io/path: "/metrics"
    spec:
      containers:
      - name: flask-api
        image: flask-api:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 5000
        env:
        - name: ENVIRONMENT
          value: "production"
        - name: LOG_LEVEL
          value: "INFO"
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
        readinessProbe:
          httpGet:
            path: /api/health
            port: 5000
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /api/health
            port: 5000
          initialDelaySeconds: 15
          periodSeconds: 20
---
apiVersion: v1
kind: Service
metadata:
  name: flask-api-service
  namespace: sre-monitoring
spec:
  selector:
    app: flask-api
  ports:
  - port: 5000
    targetPort: 5000
  type: ClusterIP
---

EOF

echo "Creating Angular files..."
mkdir -p angular-ui/src/app
mkdir -p angular-ui/src/environments
mkdir -p angular-ui/src/app/core/models
mkdir -p angular-ui/src/app/core/services
mkdir -p angular-ui/src/app/shared/components/metric-card
mkdir -p angular-ui/src/app/shared/components/alert-list
mkdir -p angular-ui/src/app/features/dashboard

cat > angular-ui/src/app/core/models/metric.model.ts << 'EOF'
export interface Metric {
  value: number;
  timestamp: string;
  name: string;
  unit: string;
}

export interface SystemMetrics {
  cpu_usage: number;
  memory_usage: number;
  disk_usage: number;
  network_io: {
    sent_bytes: number;
    received_bytes: number;
  };
}
EOF

cat > angular-ui/src/app/core/models/alert.model.ts << 'EOF'
export interface Alert {
  id: number;
  severity: 'critical' | 'warning' | 'info';
  message: string;
  timestamp: string;
  acknowledged?: boolean;
}
EOF

cat > angular-ui/src/app/core/services/api.service.ts << 'EOF'
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import { SystemMetrics } from '../models/metric.model';
import { Alert } from '../models/alert.model';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) {}

  getHealth(): Observable<any> {
    return this.http.get(`${this.apiUrl}/health`);
  }

  getMetrics(): Observable<SystemMetrics> {
    return this.http.get<SystemMetrics>(`${this.apiUrl}/metrics`);
  }

  getAlerts(severity?: string): Observable<Alert[]> {
    let url = `${this.apiUrl}/alerts`;
    if (severity) {
      url += `?severity=${severity}`;
    }
    return this.http.get<Alert[]>(url);
  }

  getConfig(): Observable<any> {
    return this.http.get(`${this.apiUrl}/config`);
  }

  simulateCpuLoad(duration: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/simulate/cpu?duration=${duration}`);
  }

  simulateMemoryLoad(sizeMb: number, duration: number): Observable<any> {
    return this.http.get(`${this.apiUrl}/simulate/memory?size_mb=${sizeMb}&duration=${duration}`);
  }

  simulateError(type: 'client' | 'server'): Observable<any> {
    return this.http.get(`${this.apiUrl}/simulate/error?type=${type}`);
  }
}
EOF

cat > angular-ui/src/app/core/services/metrics.service.ts << 'EOF'
import { Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { BehaviorSubject, Observable, interval } from 'rxjs';
import { switchMap, shareReplay } from 'rxjs/operators';
import { SystemMetrics } from '../models/metric.model';

@Injectable({
  providedIn: 'root'
})
export class MetricsService {
  private metricsSubject = new BehaviorSubject<SystemMetrics | null>(null);
  private refreshInterval = 10000; // 10 seconds
  
  metrics$ = this.metricsSubject.asObservable();
  
  constructor(private apiService: ApiService) {
    // Set up automatic polling for metrics
    this.setupMetricsPolling();
  }
  
  private setupMetricsPolling(): void {
    interval(this.refreshInterval)
      .pipe(
        switchMap(() => this.apiService.getMetrics())
      )
      .subscribe({
        next: (metrics) => this.metricsSubject.next(metrics),
        error: (error) => console.error('Error fetching metrics:', error)
      });
      
    // Initial fetch
    this.refreshMetrics();
  }
  
  refreshMetrics(): void {
    this.apiService.getMetrics().subscribe({
      next: (metrics) => this.metricsSubject.next(metrics),
      error: (error) => console.error('Error fetching metrics:', error)
    });
  }
  
  setRefreshInterval(intervalMs: number): void {
    this.refreshInterval = intervalMs;
    this.setupMetricsPolling();
  }
}
EOF

cat > angular-ui/src/app/core/services/alerts.service.ts << 'EOF'
import { Injectable } from '@angular/core';
import { ApiService } from './api.service';
import { BehaviorSubject, Observable, interval } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { Alert } from '../models/alert.model';

@Injectable({
  providedIn: 'root'
})
export class AlertsService {
  private alertsSubject = new BehaviorSubject<Alert[]>([]);
  private refreshInterval = 30000; // 30 seconds
  
  alerts$ = this.alertsSubject.asObservable();
  
  constructor(private apiService: ApiService) {
    // Set up automatic polling for alerts
    this.setupAlertsPolling();
  }
  
  private setupAlertsPolling(): void {
    interval(this.refreshInterval)
      .pipe(
        switchMap(() => this.apiService.getAlerts())
      )
      .subscribe({
        next: (alerts) => this.alertsSubject.next(alerts),
        error: (error) => console.error('Error fetching alerts:', error)
      });
      
    // Initial fetch
    this.refreshAlerts();
  }
  
  refreshAlerts(severity?: string): void {
    this.apiService.getAlerts(severity).subscribe({
      next: (alerts) => this.alertsSubject.next(alerts),
      error: (error) => console.error('Error fetching alerts:', error)
    });
  }
  
  acknowledgeAlert(alertId: number): void {
    const currentAlerts = this.alertsSubject.getValue();
    const updatedAlerts = currentAlerts.map(alert => 
      alert.id === alertId ? { ...alert, acknowledged: true } : alert
    );
    this.alertsSubject.next(updatedAlerts);
    
    // In a real app, you would call an API endpoint to persist this change
    // this.apiService.acknowledgeAlert(alertId).subscribe();
  }
}
EOF

cat > angular-ui/src/app/shared/components/metric-card/metric-card.component.ts << 'EOF'
import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-metric-card',
  template: `
    <div class="metric-card" [ngClass]="getSeverityClass()">
      <div class="metric-header">
        <h3>{{ title }}</h3>
        <span class="metric-unit">{{ unit }}</span>
      </div>
      <div class="metric-value">{{ value | number:'1.1-2' }}</div>
      <div class="metric-footer">
        <span class="trend" *ngIf="trend">
          <i class="fa" [ngClass]="getTrendIconClass()"></i>
          {{ trendValue | number:'1.1-2' }}%
        </span>
      </div>
    </div>
  `,
  styles: [`
    .metric-card {
      padding: 16px;
      border-radius: 8px;
      background-color: #fff;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      margin-bottom: 16px;
    }
    .metric-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
    }
    .metric-header h3 {
      margin: 0;
      font-size: 16px;
      font-weight: 500;
    }
    .metric-unit {
      font-size: 12px;
      color: #666;
    }
    .metric-value {
      font-size: 24px;
      font-weight: 600;
      margin-bottom: 8px;
    }
    .metric-footer {
      font-size: 12px;
    }
    .trend {
      display: flex;
      align-items: center;
    }
    .trend i {
      margin-right: 4px;
    }
    .severity-normal {
      border-left: 4px solid #4caf50;
    }
    .severity-warning {
      border-left: 4px solid #ff9800;
    }
    .severity-critical {
      border-left: 4px solid #f44336;
    }
  `]
})
export class MetricCardComponent implements OnInit {
  @Input() title: string = '';
  @Input() value: number = 0;
  @Input() unit: string = '';
  @Input() trend?: number;
  @Input() trendValue?: number;
  @Input() thresholdWarning: number = 70;
  @Input() thresholdCritical: number = 90;

  ngOnInit(): void {
  }

  getSeverityClass(): string {
    if (this.value >= this.thresholdCritical) {
      return 'severity-critical';
    } else if (this.value >= this.thresholdWarning) {
      return 'severity-warning';
    }
    return 'severity-normal';
  }

  getTrendIconClass(): string {
    if (!this.trend) return '';
    return this.trend > 0 ? 'fa-arrow-up' : 'fa-arrow-down';
  }
}
EOF

cat > angular-ui/src/app/shared/components/alert-list/alert-list.component.ts << 'EOF'
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { Alert } from '../../../core/models/alert.model';

@Component({
  selector: 'app-alert-list',
  template: `
    <div class="alert-list">
      <div *ngIf="alerts.length === 0" class="no-alerts">
        No alerts to display
      </div>
      <div *ngFor="let alert of alerts" class="alert-item" [ngClass]="'severity-' + alert.severity">
        <div class="alert-header">
          <span class="severity-badge">{{ alert.severity }}</span>
          <span class="alert-timestamp">{{ alert.timestamp | date:'short' }}</span>
        </div>
        <div class="alert-message">{{ alert.message }}</div>
        <div class="alert-actions">
          <button *ngIf="!alert.acknowledged" (click)="onAcknowledge(alert.id)">Acknowledge</button>
          <span *ngIf="alert.acknowledged" class="acknowledged-badge">Acknowledged</span>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .alert-list {
      margin-bottom: 16px;
    }
    .no-alerts {
      padding: 16px;
      text-align: center;
      color: #666;
    }
    .alert-item {
      padding: 12px;
      border-radius: 4px;
      margin-bottom: 8px;
      background-color: #fff;
      box-shadow: 0 1px 2px rgba(0,0,0,0.1);
    }
    .alert-header {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
    }
    .severity-badge {
      padding: 2px 6px;
      border-radius: 4px;
      font-size: 12px;
      text-transform: uppercase;
    }
    .alert-timestamp {
      font-size: 12px;
      color: #666;
    }
    .alert-message {
      margin-bottom: 8px;
    }
    .alert-actions {
      text-align: right;
    }
    .alert-actions button {
      padding: 4px 8px;
      border: none;
      background-color: #2196f3;
      color: white;
      border-radius: 4px;
      cursor: pointer;
    }
    .acknowledged-badge {
      font-size: 12px;
      color: #666;
      font-style: italic;
    }
    .severity-critical {
      border-left: 4px solid #f44336;
    }
    .severity-critical .severity-badge {
      background-color: #f44336;
      color: white;
    }
    .severity-warning {
      border-left: 4px solid #ff9800;
    }
    .severity-warning .severity-badge {
      background-color: #ff9800;
      color: white;
    }
    .severity-info {
      border-left: 4px solid #2196f3;
    }
    .severity-info .severity-badge {
      background-color: #2196f3;
      color: white;
    }
  `]
})
export class AlertListComponent {
  @Input() alerts: Alert[] = [];
  @Output() acknowledge = new EventEmitter<number>();

  onAcknowledge(alertId: number): void {
    this.acknowledge.emit(alertId);
  }
}
EOF

cat > angular-ui/src/app/features/dashboard/dashboard.component.ts << 'EOF'
import { Component, OnInit } from '@angular/core';
import { MetricsService } from '../../core/services/metrics.service';
import { AlertsService } from '../../core/services/alerts.service';
import { ApiService } from '../../core/services/api.service';
import { SystemMetrics } from '../../core/models/metric.model';
import { Alert } from '../../core/models/alert.model';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

@Component({
  selector: 'app-dashboard',
  template: `
    <div class="dashboard-container">
      <header class="dashboard-header">
        <h1>SRE Dashboard</h1>
        <div class="actions">
          <button (click)="refreshMetrics()">Refresh Metrics</button>
          <button (click)="openSettings()">Settings</button>
        </div>
      </header>

      <div class="dashboard-content">
        <div class="metrics-section">
          <h2>System Metrics</h2>
          <div class="metrics-grid">
            <app-metric-card
              title="CPU Usage"
              [value]="(metrics$ | async)?.cpu_usage || 0"
              unit="%"
              [thresholdWarning]="70"
              [thresholdCritical]="90"
            ></app-metric-card>
            
            <app-metric-card
              title="Memory Usage"
              [value]="(metrics$ | async)?.memory_usage || 0"
              unit="%"
              [thresholdWarning]="80"
              [thresholdCritical]="95"
            ></app-metric-card>
            
            <app-metric-card
              title="Disk Usage"
              [value]="(metrics$ | async)?.disk_usage || 0"
              unit="%"
              [thresholdWarning]="75"
              [thresholdCritical]="90"
            ></app-metric-card>
            
            <app-metric-card
              title="Network Sent"
              [value]="((metrics$ | async)?.network_io?.sent_bytes || 0) / (1024 * 1024)"
              unit="MB"
            ></app-metric-card>
            
            <app-metric-card
              title="Network Received"
              [value]="((metrics$ | async)?.network_io?.received_bytes || 0) / (1024 * 1024)"
              unit="MB"
            ></app-metric-card>
          </div>
        </div>

        <div class="alerts-section">
          <h2>Recent Alerts</h2>
          <div class="alerts-filter">
            <button 
              [ngClass]="{'active': currentSeverityFilter === ''}"
              (click)="filterAlerts('')">All</button>
            <button 
              [ngClass]="{'active': currentSeverityFilter === 'critical'}"
              (click)="filterAlerts('critical')">Critical</button>
            <button 
              [ngClass]="{'active': currentSeverityFilter === 'warning'}"
              (click)="filterAlerts('warning')">Warning</button>
            <button 
              [ngClass]="{'active': currentSeverityFilter === 'info'}"
              (click)="filterAlerts('info')">Info</button>
          </div>
          <app-alert-list
            [alerts]="alerts$ | async"
            (acknowledge)="acknowledgeAlert($event)"
          ></app-alert-list>
        </div>

        <div class="simulation-section">
          <h2>Test Utilities</h2>
          <div class="simulation-grid">
            <div class="simulation-card">
              <h3>CPU Load Test</h3>
              <div class="form-group">
                <label for="cpu-duration">Duration (seconds):</label>
                <input id="cpu-duration" type="number" [(ngModel)]="cpuTestDuration" min="1" max="30">
              </div>
              <button [disabled]="isTestRunning" (click)="simulateCpuLoad()">Run Test</button>
            </div>
            
            <div class="simulation-card">
              <h3>Memory Load Test</h3>
              <div class="form-group">
                <label for="memory-size">Size (MB):</label>
                <input id="memory-size" type="number" [(ngModel)]="memoryTestSize" min="1" max="100">
              </div>
              <div class="form-group">
                <label for="memory-duration">Duration (seconds):</label>
                <input id="memory-duration" type="number" [(ngModel)]="memoryTestDuration" min="1" max="30">
              </div>
              <button [disabled]="isTestRunning" (click)="simulateMemoryLoad()">Run Test</button>
            </div>
            
            <div class="simulation-card">
              <h3>Error Simulation</h3>
              <div class="form-group">
                <label for="error-type">Error Type:</label>
                <select id="error-type" [(ngModel)]="errorType">
                  <option value="client">Client Error (400)</option>
                  <option value="server">Server Error (500)</option>
                </select>
              </div>
              <button [disabled]="isTestRunning" (click)="simulateError()">Simulate Error</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .dashboard-container {
      padding: 16px;
      max-width: 1200px;
      margin: 0 auto;
    }
    .dashboard-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
    }
    .dashboard-header h1 {
      margin: 0;
    }
    .actions button {
      margin-left: 8px;
      padding: 8px 16px;
      background-color: #2196f3;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .metrics-section, .alerts-section, .simulation-section {
      margin-bottom: 32px;
    }
    .metrics-section h2, .alerts-section h2, .simulation-section h2 {
      margin-top: 0;
      margin-bottom: 16px;
      font-size: 20px;
    }
    .metrics-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 16px;
    }
    .alerts-filter {
      margin-bottom: 16px;
    }
    .alerts-filter button {
      margin-right: 8px;
      padding: 4px 12px;
      background-color: #f0f0f0;
      border: 1px solid #ddd;
      border-radius: 4px;
      cursor: pointer;
    }
    .alerts-filter button.active {
      background-color: #2196f3;
      color: white;
      border-color: #2196f3;
    }
    .simulation-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 16px;
    }
    .simulation-card {
      padding: 16px;
      background-color: #f9f9f9;
      border-radius: 8px;
      border: 1px solid #eee;
    }
    .simulation-card h3 {
      margin-top: 0;
      margin-bottom: 16px;
      font-size: 16px;
    }
    .form-group {
      margin-bottom: 12px;
    }
    .form-group label {
      display: block;
      margin-bottom: 4px;
      font-size: 14px;
    }
    .form-group input, .form-group select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ddd;
      border-radius: 4px;
    }
    .simulation-card button {
      width: 100%;
      padding: 8px 16px;
      background-color: #4caf50;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    .simulation-card button:disabled {
      background-color: #ccc;
      cursor: not-allowed;
    }
  `]
})
export class DashboardComponent implements OnInit {
  metrics$: Observable<SystemMetrics | null>;
  alerts$: Observable<Alert[]>;
  
  currentSeverityFilter: string = '';
  isTestRunning: boolean = false;
  
  // Simulation controls
  cpuTestDuration: number = 5;
  memoryTestSize: number = 10;
  memoryTestDuration: number = 5;
  errorType: 'client' | 'server' = 'client';
  
  constructor(
    private metricsService: MetricsService,
    private alertsService: AlertsService,
    private apiService: ApiService
  ) {
    this.metrics$ = this.metricsService.metrics$;
    this.alerts$ = this.alertsService.alerts$;
  }
  
  ngOnInit(): void {
    // Initial data fetch
    this.refreshMetrics();
    this.alertsService.refreshAlerts();
  }
  
  refreshMetrics(): void {
    this.metricsService.refreshMetrics();
  }
  
  filterAlerts(severity: string): void {
    this.currentSeverityFilter = severity;
    this.alertsService.refreshAlerts(severity);
  }
  
  acknowledgeAlert(alertId: number): void {
    this.alertsService.acknowledgeAlert(alertId);
  }
  
  openSettings(): void {
    // In a real app, this would open a settings dialog
    alert('Settings functionality would go here');
  }
  
  simulateCpuLoad(): void {
    this.isTestRunning = true;
    this.apiService.simulateCpuLoad(this.cpuTestDuration).subscribe({
      next: (response) => {
        console.log('CPU test response:', response);
        this.isTestRunning = false;
        // Refresh metrics after test
        setTimeout(() => this.refreshMetrics(), 1000);
      },
      error: (error) => {
        console.error('CPU test error:', error);
        this.isTestRunning = false;
      }
    });
  }
  
  simulateMemoryLoad(): void {
    this.isTestRunning = true;
    this.apiService.simulateMemoryLoad(this.memoryTestSize, this.memoryTestDuration).subscribe({
      next: (response) => {
        console.log('Memory test response:', response);
        this.isTestRunning = false;
        // Refresh metrics after test
        setTimeout(() => this.refreshMetrics(), 1000);
      },
      error: (error) => {
        console.error('Memory test error:', error);
        this.isTestRunning = false;
      }
    });
  }
  
  simulateError(): void {
    this.isTestRunning = true;
    this.apiService.simulateError(this.errorType).subscribe({
      next: (response) => {
        // This shouldn't happen
        console.log('Error simulation response:', response);
        this.isTestRunning = false;
      },
      error: (error) => {
        console.log('Error simulated successfully:', error);
        this.isTestRunning = false;
        // Refresh alerts after error
        setTimeout(() => this.alertsService.refreshAlerts(), 1000);
      }
    });
  }
}
EOF

cat > angular-ui/src/app/app.module.ts << 'EOF'
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { FormsModule } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';

import { AppComponent } from './app.component';
import { MetricCardComponent } from './shared/components/metric-card/metric-card.component';
import { AlertListComponent } from './shared/components/alert-list/alert-list.component';
import { DashboardComponent } from './features/dashboard/dashboard.component';

const routes: Routes = [
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: 'dashboard', component: DashboardComponent },
];

@NgModule({
  declarations: [
    AppComponent,
    MetricCardComponent,
    AlertListComponent,
    DashboardComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    FormsModule,
    RouterModule.forRoot(routes)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
EOF

cat > angular-ui/src/app/app.component.ts << 'EOF'
import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
    <div class="app-container">
      <nav class="sidebar">
        <div class="sidebar-header">
          <h2>SRE Portal</h2>
        </div>
        <ul class="nav-links">
          <li><a routerLink="/dashboard" routerLinkActive="active">Dashboard</a></li>
          <li><a routerLink="/metrics" routerLinkActive="active">Metrics</a></li>
          <li><a routerLink="/alerts" routerLinkActive="active">Alerts</a></li>
          <li><a routerLink="/config" routerLinkActive="active">Configuration</a></li>
        </ul>
      </nav>
      <main class="main-content">
        <router-outlet></router-outlet>
      </main>
    </div>
  `,
  styles: [`
    .app-container {
      display: flex;
      height: 100vh;
    }
    .sidebar {
      width: 250px;
      background-color: #2c3e50;
      color: white;
    }
    .sidebar-header {
      padding: 16px;
      border-bottom: 1px solid #34495e;
    }
    .sidebar-header h2 {
      margin: 0;
      font-size: 20px;
    }
    .nav-links {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .nav-links li a {
      display: block;
      padding: 12px 16px;
      color: #ecf0f1;
      text-decoration: none;
      border-left: 4px solid transparent;
    }
    .nav-links li a:hover {
      background-color: #34495e;
    }
    .nav-links li a.active {
      background-color: #34495e;
      border-left: 4px solid #3498db;
    }
    .main-content {
      flex: 1;
      overflow-y: auto;
      background-color: #f5f5f5;
    }
  `]
})
export class AppComponent {
  title = 'sre-dashboard';
}
EOF

cat > angular-ui/src/environments/environment.ts << 'EOF'
export const environment = {
  production: false,
  apiUrl: 'http://localhost:5000/api'
};
EOF

cat > angular-ui/src/environments/environment.prod.ts << 'EOF'
export const environment = {
  production: true,
  apiUrl: '/api'
};
EOF

# Create Angular files (this will be simplified since we'll create only the essential structure)
cat > angular-ui/package.json << 'EOF'
{
  "name": "sre-dashboard",
  "version": "0.0.0",
  "scripts": {
    "ng": "ng",
    "start": "ng serve",
    "build": "ng build",
    "watch": "ng build --watch --configuration development",
    "test": "ng test"
  },
  "private": true,
  "dependencies": {
    "@angular/animations": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/compiler": "^17.0.0",
    "@angular/core": "^17.0.0",
    "@angular/forms": "^17.0.0",
    "@angular/platform-browser": "^17.0.0",
    "@angular/platform-browser-dynamic": "^17.0.0",
    "@angular/router": "^17.0.0",
    "rxjs": "~7.8.0",
    "tslib": "^2.3.0",
    "zone.js": "~0.14.2"
  },
  "devDependencies": {
    "@angular-devkit/build-angular": "^17.0.0",
    "@angular/cli": "^17.0.0",
    "@angular/compiler-cli": "^17.0.0",
    "@types/jasmine": "~5.1.0",
    "jasmine-core": "~5.1.0",
    "karma": "~6.4.0",
    "karma-chrome-launcher": "~3.2.0",
    "karma-coverage": "~2.2.0",
    "karma-jasmine": "~5.1.0",
    "karma-jasmine-html-reporter": "~2.1.0",
    "typescript": "~5.2.2"
  }
}
EOF

cat > angular-ui/angular.json << 'EOF'
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "newProjectRoot": "projects",
  "projects": {
    "sre-dashboard": {
      "projectType": "application",
      "schematics": {},
      "root": "",
      "sourceRoot": "src",
      "prefix": "app",
      "architect": {
        "build": {
          "builder": "@angular-devkit/build-angular:browser",
          "options": {
            "outputPath": "dist/sre-dashboard",
            "index": "src/index.html",
            "main": "src/main.ts",
            "polyfills": [
              "zone.js"
            ],
            "tsConfig": "tsconfig.app.json",
            "assets": [
              "src/favicon.ico",
              "src/assets"
            ],
            "styles": [
              "src/styles.css"
            ],
            "scripts": []
          },
          "configurations": {
            "production": {
              "budgets": [
                {
                  "type": "initial",
                  "maximumWarning": "500kb",
                  "maximumError": "1mb"
                },
                {
                  "type": "anyComponentStyle",
                  "maximumWarning": "2kb",
                  "maximumError": "4kb"
                }
              ],
              "outputHashing": "all"
            },
            "development": {
              "buildOptimizer": false,
              "optimization": false,
              "vendorChunk": true,
              "extractLicenses": false,
              "sourceMap": true,
              "namedChunks": true
            }
          },
          "defaultConfiguration": "production"
        },
        "serve": {
          "builder": "@angular-devkit/build-angular:dev-server",
          "configurations": {
            "production": {
              "browserTarget": "sre-dashboard:build:production"
            },
            "development": {
              "browserTarget": "sre-dashboard:build:development"
            }
          },
          "defaultConfiguration": "development"
        },
        "extract-i18n": {
          "builder": "@angular-devkit/build-angular:extract-i18n",
          "options": {
            "browserTarget": "sre-dashboard:build"
          }
        },
        "test": {
          "builder": "@angular-devkit/build-angular:karma",
          "options": {
            "polyfills": [
              "zone.js",
              "zone.js/testing"
            ],
            "tsConfig": "tsconfig.spec.json",
            "assets": [
              "src/favicon.ico",
              "src/assets"
            ],
            "styles": [
              "src/styles.css"
            ],
            "scripts": []
          }
        }
      }
    }
  }
}
EOF

cat > angular-ui/Dockerfile << 'EOF'
# Dockerfile for Angular App
FROM node:18 as build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build --prod

# Production stage
FROM nginx:alpine

# Copy the build output to replace the default nginx contents
COPY --from=build /app/dist/sre-dashboard /usr/share/nginx/html

# Copy our custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
EOF

cat > angular-ui/nginx.conf << 'EOF'
server {
    listen 80;
    server_name localhost;
    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Forward API requests to the backend service
    location /api/ {
        proxy_pass http://flask-api-service:5000/api/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    # Add resolver for Kubernetes service discovery
    resolver kube-dns.kube-system.svc.cluster.local valid=10s;
}
EOF

echo "Creating Angular Kubernetes configuration..."
mkdir -p k8s/angular-ui
cat > k8s/angular-ui/deployment.yaml << 'EOF'
# Kubernetes deployment content - copy from Angular Dockerfile artifact
# Kubernetes deployment file
# Save this as angular-ui-deployment.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: angular-ui
  namespace: sre-monitoring
  labels:
    app: angular-ui
spec:
  replicas: 1
  selector:
    matchLabels:
      app: angular-ui
  template:
    metadata:
      labels:
        app: angular-ui
    spec:
      containers:
      - name: angular-ui
        image: angular-ui:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 20
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 10
---
EOF

cat > k8s/angular-ui/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: angular-ui-service
  namespace: sre-monitoring
spec:
  selector:
    app: angular-ui
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
---
EOF

cat > k8s/angular-ui/ingress.yaml << 'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sre-app-ingress
  namespace: sre-monitoring
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  rules:
  - http:
      paths:
      - path: /(.*)
        pathType: Prefix
        backend:
          service:
            name: angular-ui-service
            port:
              number: 80
---
EOF

# Create a README file
cat > README.md << 'EOF'
# SRE Application Setup

This repository contains all the necessary scripts and configurations to set up a complete SRE environment with:

- WSL (Windows Subsystem for Linux)
- Minikube
- Prometheus for monitoring
- Grafana for visualization
- Flask API backend
- Angular UI frontend

## Prerequisites

- Windows 10/11 with WSL capability
- Administrative privileges
- Internet connection

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/sre-app.git
   cd sre-app
   ```

2. Run the setup script:
   ```
   ./setup.sh
   ```

3. Follow the on-screen instructions.

## Accessing the Applications

After installation, you can access:

- Angular UI: http://localhost (via Minikube Ingress)
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (username: admin, password: admin)

## Features

- Complete SRE environment
- Metrics visualization
- CPU and memory usage monitoring
- Test utilities for simulating load
- Alert management

## Troubleshooting

If you encounter any issues, please check the logs:

```
kubectl logs -n sre-monitoring deployment/angular-ui
kubectl logs -n sre-monitoring deployment/flask-api
kubectl logs -n sre-monitoring deployment/prometheus
kubectl logs -n sre-monitoring deployment/grafana
```

## License

MIT
EOF

# Create the main setup script
cat > setup.sh << 'EOF'
#!/bin/bash

set -e

echo "========== SRE Application Setup Script =========="
echo "This script will set up the complete SRE environment"

# Check if running on Windows with WSL
if [[ "$(uname -r)" != *Microsoft* ]] && [[ "$(uname -r)" != *microsoft* ]]; then
  echo "This script is intended to be run on Windows with WSL."
  echo "If you've already installed WSL, you can continue. Otherwise, please install WSL first."
  read -p "Continue? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Step 1: Set up WSL and Minikube
echo "Step 1: Setting up WSL and Minikube..."
./wsl-setup/setup-wsl-minikube.sh

# Step 2: Build and deploy the Flask API
echo "Step 2: Building and deploying the Flask API..."
cd flask-api
docker build -t flask-api:latest .
cd ..

kubectl apply -f k8s/flask-api/deployment.yaml

# Step 3: Build and deploy the Angular UI
echo "Step 3: Building and deploying the Angular UI..."
cd angular-ui
# In a real script, we would build the Angular app here
# For brevity, we'll just build the Docker image
docker build -t angular-ui:latest .
cd ..

kubectl apply -f k8s/angular-ui/deployment.yaml

# Step 4: Set up Prometheus
echo "Step 4: Setting up Prometheus..."
./prometheus/setup-prometheus.sh

# Step 5: Set up Grafana
echo "Step 5: Setting up Grafana..."
./grafana/setup-grafana.sh

echo "==========================================="
echo "SRE Application setup completed successfully!"
echo "Access your applications at:"
echo "- Angular UI: http://$(minikube ip)"
echo "- Prometheus: http://localhost:9090 (port-forwarded)"
echo "- Grafana: http://localhost:3000 (port-forwarded)"
echo "  Username: admin"
echo "  Password: admin"
echo "==========================================="
EOF
chmod +x setup.sh

echo "==========================================="
echo "Project structure has been created at: $PROJECT_ROOT"
echo "To start the setup, run:"
echo "cd $PROJECT_ROOT"
echo "./setup.sh"
echo "==========================================="
echo "Note: The setup script expects you to edit the placeholder scripts"
echo "and replace them with the actual script content from the provided artifacts."
echo "============================================="

