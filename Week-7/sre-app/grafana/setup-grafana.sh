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
