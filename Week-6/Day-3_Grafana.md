# Lightweight SRE Monitoring Setup

## Features
- **Automated Minikube Setup**: Ensures a clean Minikube environment.
- **Lightweight Flask API**: Includes Prometheus-based monitoring for request count, latency, and errors.
- **Minimal Kubernetes Resource Usage**: Optimized deployment for low-resource environments.
- **Integrated Monitoring Stack**:
  - **Prometheus**: Collects application and infrastructure metrics.
  - **Loki**: Handles log aggregation.
  - **Grafana**: Provides dashboards for real-time monitoring.
- **Load Testing**: Simulates traffic to validate monitoring metrics.

---
## Application Code Breakdown

### **Flask App Overview**
This is a **Flask-based API** designed for monitoring and observability. It includes endpoints for:
- **Fetching users (`/api/users`)** - Simulates a database query with variable latency. Returns a small list of users:
  ```json
  [
    {"id": 1, "name": "Alice", "email": "alice@example.com"},
    {"id": 2, "name": "Bob", "email": "bob@example.com"}
  ]
  ```
- **Echoing JSON (`/api/echo`)** - Accepts JSON input and returns it unmodified. Example request:
  ```json
  {"message": "Hello"}
  ```
  Response:
  ```json
  {"message": "Hello"}
  ```
- **Simulating errors (`/api/error`)** - Generates intentional errors based on query parameters:
  - `?type=client` returns a **400 Bad Request**.
  - Default generates a **500 Internal Server Error**.
- **Health Checks (`/health/liveness` and `/health/readiness`)** - Used by Kubernetes probes to check if the app is running and ready.

### **Prometheus Integration**
Prometheus is integrated using the `prometheus_client` library:
- **Metrics Defined:**
  - `REQUEST_COUNT`: Tracks total API requests.
  - `REQUEST_LATENCY`: Measures response time distributions.
  - `ERROR_COUNTER`: Tracks error occurrences.
  - `ACTIVE_REQUESTS`: Monitors active requests in processing.
- **How It Works in Code:**
  - These metrics are defined in `app.py`: 
    ```python
    REQUEST_COUNT = Counter(
        'app_request_count', 
        'Application Request Count',
        ['endpoint', 'method', 'http_status']
    )
    REQUEST_LATENCY = Histogram(
        'app_request_latency_seconds', 
        'Application Request Latency',
        ['endpoint', 'method'],
        buckets=[0.01, 0.05, 0.1, 0.5, 1, 2, 5]
    )
    ERROR_COUNTER = Counter(
        'app_error_count',
        'Application Error Count',
        ['error_type', 'endpoint']
    )
    ACTIVE_REQUESTS = Gauge(
        'app_active_requests',
        'Active Requests Currently Being Processed'
    )
    ```
- **Middleware Hooks:**
  - `@app.before_request`: Starts request tracking:
    ```python
    @app.before_request
    def before_request():
        request.start_time = time.time()
        ACTIVE_REQUESTS.inc()
        request.request_id = str(random.randint(1000, 9999))
    ```
  - `@app.after_request`: Logs and updates metrics:
    ```python
    @app.after_request
    def after_request(response):
        ACTIVE_REQUESTS.dec()
        request_time = time.time() - request.start_time
        REQUEST_LATENCY.labels(endpoint=request.path, method=request.method).observe(request_time)
        REQUEST_COUNT.labels(endpoint=request.path, method=request.method, http_status=response.status_code).inc()
        return response
    ```
- **Prometheus Endpoint (`/metrics`)**:
  - Exposes application metrics for Prometheus scraping:
    ```python
    from prometheus_client import make_wsgi_app
    from werkzeug.middleware.dispatcher import DispatcherMiddleware
    app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {'/metrics': make_wsgi_app()})
    ```

### **Loki & Logging Integration**
- **Structured Logging Implementation:**
  - The Flask app uses Python’s `logging` module to structure logs:
    ```python
    import logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s [%(levelname)s] %(message)s - request_id=%(request_id)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    ```
- **Error Logging:**
  - Errors are tagged and counted in Prometheus:
    ```python
    if random.random() < 0.02:  # Simulated 2% error rate
        ERROR_COUNTER.labels(error_type="database_error", endpoint="/api/users").inc()
        logging.error("Database error occurred: Failed to retrieve users")
    ```
- **Loki Integration via Promtail:**
  - Promtail collects logs from Kubernetes pods and sends them to Loki.
  - Loki configuration is handled in `loki-values.yaml`.

---
## Kubernetes Monitoring Stack

### **Prometheus Configuration (`prometheus-values.yaml`)**
This defines a **lightweight Prometheus setup**:
```yaml
alertmanager:
  enabled: false
pushgateway:
  enabled: false
nodeExporter:
  enabled: false
server:
  persistentVolume:
    enabled: false
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
    limits:
      cpu: 200m
      memory: 512Mi
```

### **Loki Configuration (`loki-values.yaml`)**
Loki is configured for **log aggregation**:
```yaml
loki:
  persistence:
    enabled: false
  resources:
    requests:
      cpu: 50m
      memory: 128Mi
    limits:
      cpu: 100m
      memory: 256Mi
promtail:
  config:
    snippets:
      pipelineStages:
        - docker: {}
```

---
### Grafana Dashboards & Visualizations for Application Metrics
<p align="center">
  <img src="../images/day-27/screenshot2.jpg" width="75%" alt="Image">
</p><p align="center">
  <img src="../images/day-27/screenshot3.jpg" width="75%" alt="Image">
</p><p align="center">
  <img src="../images/day-27/screenshot4.jpg" width="75%" alt="Image">

---

# **Key Metrics in Prometheus for Observability**  

## **Latency**  
**Definition:** How long it takes to serve a customer from when they order.  
**In our script:** We measure how long each web request takes to complete using `app_request_latency_seconds`. Just like timing how long it takes from a customer ordering food until they receive it.  

## **Traffic**  
**Definition:** How many customers are coming in per hour.  
**In our script:** We count incoming requests with `app_request_count`. This is like having a counter at the restaurant door that clicks each time someone enters.  

## **Errors**  
**Definition:** How many orders are returned or complaints received.  
**In our script:** We track HTTP error codes (like `500` errors) and explicit error counters. This is like tracking how many dishes are sent back to the kitchen or how many customers complain.  

## **Saturation**  
**Definition:** How close the restaurant is to maximum capacity.  
**In our script:** We use `app_active_requests` to see how many requests are being processed simultaneously. This is like counting how many tables are occupied at once in the restaurant.  

---

# **Observability Foundations**  

Think of operating a commercial airplane:  

- **Metrics:** Quantitative measurements like altitude, speed, and fuel level.  
  - **In our script:** Prometheus collects precise numbers about our system's performance, like counting requests or measuring response times.  

- **Logs:** The flight recorder (black box) that captures detailed events.  
  - **In our script:** Our application writes detailed logs with timestamps and request IDs, collected by Loki. This is like recording every action taken by pilots and every system event.  

- **Visualization:** The cockpit dashboard that displays important readings.  
  - **In our script:** Grafana creates visual dashboards that make it easy to understand system behavior at a glance.  

- **Instrumentation:** The sensors throughout the aircraft that capture data.  
  - **In our script:** We've added code to the application to capture key information about its behavior.  

---

# **Health Monitoring**  

Think of a doctor checking a patient's health:  

- **Liveness Probes:** Checking if the patient is alive (basic pulse check).  
  - **In our script:** The `/health/liveness` endpoint tells Kubernetes if our application is running at all.  

- **Readiness Probes:** Determining if the patient can perform activities.  
  - **In our script:** The `/health/readiness` endpoint checks if our application can handle requests properly.  

- **Health Endpoints:** Different types of medical tests (blood pressure, temperature, etc.).  
  - **In our script:** We have different endpoints that check different aspects of health.  

- **Dependency Checks:** Making sure all organs are functioning together.  
  - **In our script:** We verify our "database connection" is working before declaring the app ready.  

---

# **Service Level Objectives (SLO) Building Blocks**  

Think of a pizza delivery promise:  

- **Error Rate Tracking:** Monitoring how many pizzas are delivered incorrectly.  
  - **In our script:** We track how many requests result in errors.  

- **Latency Histograms:** Recording delivery times across all orders.  
  - **In our script:** We track request durations in different "buckets" to understand response time patterns.  

- **Request Success Rate:** Calculating what percentage of pizzas are delivered correctly.  
  - **In our script:** We can determine what percentage of requests complete successfully.  

These are the building blocks to create promises like **"95% of pizzas will be delivered correctly within 30 minutes"** (similar to **"99.9% of requests will complete successfully in under 500ms"**).  

