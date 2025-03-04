# Day-16 SRE Training

## Topic: Kubernetes

Kubernetes (K8s) is an open-source container orchestration platform that automates deployment, scaling, scheduling, service discovery, and self-healing of containerized applications.

Docker is a container runtime that packages applications and their dependencies into containers. In Kubernetes, Docker (or other runtimes like containerd) is used to run these containers within Pods.

### Need for Scaling, Scheduling, Service Discovery, and Self-Healing in Kubernetes:

- **Scaling** – Ensures applications handle traffic efficiently by automatically increasing/decreasing the number of running container instances.
- **Scheduling** – Assigns Pods to optimal worker nodes based on resource availability, affinity, and constraints.
- **Service Discovery** – Helps containers communicate within the cluster using internal DNS, without needing fixed IPs.
- **Self-Healing** – Restarts failed containers, replaces unresponsive nodes, and maintains the desired application state automatically.

## Kubernetes Control Plane

Kubernetes has a **Control Plane** that manages the cluster and handles scaling, scheduling, service discovery, and self-healing.

### Analogy: Planning a City Infrastructure

| Component | Function | Analogy |
|-----------|----------|---------|
| **API Server** | Acts as the entry point for all operations, handling requests via REST API. | **Planning Department** – Receives and processes all requests for new developments. |
| **etcd** | A distributed key-value store that maintains the cluster state. | **Record Keeping Office** – Stores important records like zoning plans and building approvals. |
| **Scheduler** | Assigns Pods to worker nodes based on resource constraints. | **Job Assignment Board** – Allocates work based on skills and availability. |
| **Controller Manager** | Monitors and ensures the cluster state matches the desired state. | **Operations Team** – Ensures everything runs smoothly and corrects failures. |

## Kubernetes Cluster

A Kubernetes Cluster is a group of computers (nodes) working together to run and manage applications in containers.

### Analogy: Food Delivery Network (Swiggy/Zomato)

- **Control Plane (Management Team)**
  - The API Server takes user requests (e.g., order placement).
  - The Scheduler assigns new orders to delivery workers.
  - The Controller Manager ensures all orders are delivered.

- **Worker Nodes (Delivery Partners)**
  - Each worker node (shopping complex) hosts multiple restaurants (Pods) serving customers.
  - If one restaurant (Pod) shuts down, another branch in the same or different shopping complex (node) takes over (self-healing).
  - Orders (traffic) are distributed across restaurants based on demand (scaling).

## Node in Kubernetes

A **Node** is a physical or virtual machine that runs containerized applications as part of a Kubernetes cluster. Each node contains components to manage **Pods**, which host application containers.

### Analogy: A Shopping Complex

A node provides infrastructure where multiple restaurants (Pods) operate, ensuring smooth service!

### Key Components of a Node:

1. **Kubelet (Node Agent)** – Ensures that the Pods and containers run correctly.
   - **Analogy**: Restaurant Manager – Ensures the restaurant (Pod) is open and running smoothly.

2. **Container Runtime (Docker, containerd, CRI-O)** – Manages containers inside Pods.
   - **Analogy**: Cooking Equipment – Different kitchens use different stoves (Docker, containerd, etc.), but the cooking process remains the same.

3. **Kube Proxy (Networking & Service Discovery)** – Manages network communication between Pods.
   - **Analogy**: Order Dispatcher – Routes orders to the right restaurant (Pod), manages communication, and balances traffic.

## Kubernetes Objects

### **Pod**
A **Pod** is the smallest deployable unit in Kubernetes, consisting of one or more containers that share storage, networking, and configurations.

- **Analogy**: A restaurant branch (serves customers). Containers inside Pods are like kitchen chefs working together.

### **Namespace**
A **Namespace** logically separates and organizes Kubernetes resources within a cluster.

- **Analogy**: City Districts – Different areas in a city where specific types of restaurants (Pods) operate.

### **Deployment**
A **Deployment** manages the creation, scaling, and updates of Pods.

- **Analogy**: District Manager – Ensures a required number of restaurant branches (Pods) are open and scales them as needed.

### **ConfigMap**
A **ConfigMap** stores configuration data separately from the application code.

- **Analogy**: Recipe Book – Stores recipes separately so menu changes don’t require hiring new chefs.

### **Service**
A **Service** provides a stable network endpoint for Pods, allowing communication between them or exposing applications externally.

- **Analogy**: Food Delivery Platform (Uber Eats) – Customers always order from the same app, even if restaurant locations change.

## Kubernetes Ingress
**Ingress** is a Kubernetes resource that manages external access to services inside a cluster, typically via HTTP/HTTPS.

**Key Features:**
- Routes traffic to different services based on paths or domains.
- Supports load balancing and SSL termination.

**Analogy:** **Mall Entrance & Signboards** – Just like a mall entrance directs customers to various restaurants inside based on signboards (paths), Ingress routes incoming traffic to the right service inside the cluster.

---

## Kubernetes Commands & Their Analogies

```sh
kubectl apply -f deployment.yaml
```
- Creates or updates a Deployment from the `deployment.yaml` file.
- **Analogy**: A district manager opens new restaurant branches based on a pre-approved plan.

```sh
kubectl get pods
```
- Lists all running Pods in the cluster.
- **Analogy**: Checking which restaurant branches (Pods) are currently open.

```sh
kubectl describe pod pod_name
```
- Shows detailed information about a Pod.
- **Analogy**: Asking a restaurant manager (Kubelet) for a full status report.

```sh
kubectl logs pod_name
```
- Fetches the logs generated by a Pod’s container.
- **Analogy**: Checking the restaurant’s order history to troubleshoot issues.

```sh
kubectl scale deployment deployment_name --replicas=5
```
- Adjusts the number of running Pods for a Deployment.
- **Analogy**: The district manager opens more restaurant branches during peak hours.

```sh
kubectl set image deployment/deployment_name container_name=new_image:v2
```
- Updates the running container image in a Deployment without downtime.
- **Analogy**: Upgrading kitchen equipment in all restaurant branches without shutting them down.
