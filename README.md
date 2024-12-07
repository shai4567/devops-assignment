# devops-assignment

## Useful commands Commands:
* Create VM using Vagrant:
```bash
# Assuming you are running from the VagrantFile dir:
vagrant up
```

* Delete VM using Vagrant:
```bash
# Assuming you are running from the VagrantFile dir:
vagrant destroy
```

* SSH into the Vagrant VM using ssh:
```bash
# Assuming you are running from the VagrantFile dir:
vagrant ssh
```
<!-- bazel build //backend:devops_assignment_image -->

## Running the app using 2 docker images from the host:
1. create docker network for the 2 containers to communicate:
```bash
docker network create app-network
```
2. create mongodb container:
```bash
docker run -d \
  --name mongodb \
  --network app-network \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD=rootpassword \
  -p 27017:27017 \
  mongo:latest
```
or without password:
```bash
docker run -d \
  --name mongodb \
  --network app-network \
  -p 27017:27017 \
  mongo:latest --noauth

```

3. Build nodejs app:
```bash
docker build -t nodeapp .
```

4. run the app container using the same network:
```bash
docker run -d \
  --name nodeapp:1.0.0 \
  --network app-network \
  -p 3000:3000 \
  nodeapp
```
