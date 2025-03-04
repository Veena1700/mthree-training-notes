# Day-11 SRE Training

## Topic: Docker

Docker is a containerization platform that allows developers to package applications and their dependencies into lightweight, portable containers. These containers ensure that applications run consistently across different environments.

### What Does Docker Do?
- Encapsulates applications with all dependencies (libraries, configs, etc.).
- Ensures consistency across development, testing, and production.
- Reduces conflicts between different environments.
- Improves scalability and deployment speed.

### What is a Docker Image?
- A **Docker Image** is a **read-only template** containing everything needed to run an application (OS, libraries, dependencies, and app code).
- It serves as a blueprint to create **containers**.
- Docker images are stored in a specific format known as the **Docker image format**, which consists of several layers and metadata.

### What is a Docker Container?
- A **Docker Container** is a **running instance** of an image.
- It is an isolated environment that runs an application with all dependencies included.

### Three Main Parts of Docker
1. **Docker CLI (Command-Line Interface)**
   - The **Docker CLI** allows users to interact with Docker using commands.
2. **Docker Daemon (dockerd)**
   - The Docker Daemon is the background service that manages containers, images, networks, and storage.
3. **Docker Registry**
   - A **Docker Registry** stores and distributes Docker images.

### Dockerfile

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV FLASK_APP=src/main.py
ENV FLASK_ENV=development
ENV PYTHONPATH=/app
EXPOSE 5000
CMD ["gunicorn","--bind","0.0.0.0:5000","src.main:app"]
```

#### Explanation:
1. `FROM python:3.9-slim` - Specifies the base image.
2. `WORKDIR /app` - Sets the working directory.
3. `COPY requirements.txt .` - Copies the dependency file.
4. `RUN pip install --no-cache-dir -r requirements.txt` - Installs dependencies.
5. `COPY . .` - Copies all files to the container.
6. `ENV FLASK_APP=src/main.py` - Defines the Flask app entry point.
7. `ENV FLASK_ENV=development` - Enables debug mode.
8. `ENV PYTHONPATH=/app` - Adds `/app` to the Python module search path.
9. `EXPOSE 5000` - Exposes port 5000.
10. `CMD` - Runs Gunicorn to serve the Flask app.

### Building and Running Docker Images

#### Build the image:
```sh
docker build -t python-docker-app .
```

#### List Docker images:
```sh
docker images
```

#### Run the container:
```sh
docker run -d -p 5000:5000 python-docker-app
```
- `-d` : Runs in detached mode.
- `-p 5000:5000` : Maps port 5000 of the container to port 5000 on the host.
- `python-docker-app` : Image name.

#### Tagging an Image:
```sh
sudo docker tag python-docker-app:latest veena1700/python-docker-app:v1
```
- Helps in versioning Docker images.

#### Push the Image to Docker Hub:
```sh
docker push veena1700/python-docker-app:v1
```
- Uploads the image to Docker Hub.

### Docker Compose

A `docker-compose.yml` file defines and manages multi-container applications.

#### Example `docker-compose.yml`

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "5000:5000"
```

#### Running Docker Compose:
```sh
docker-compose up --build
```
- `--build` - Ensures Docker images are built before starting containers.
- `up` - Starts services defined in the file.

With a single command, Docker Compose simplifies managing complex applications.

