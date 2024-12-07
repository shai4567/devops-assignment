# devops-assignment

## Agenda:
Set up an automatic infrastructure that will:
1. Create a new VM of Rocky Linux using Vagrant and Oracle virtualbox
2. k3s cluster should serve a sample nodejs and mongodb app
3. Everything should be managed using helm charts
4. The access into app should be ssl certified under the DNS nice-assignment.local (HTTPS)
5. The exposing of the app should be via ingress controller
6. Everything should be provisioned automatically using Google Bazel

## Step by step to run it manually:
### Provide the VM using Vagrant:
The VM itself will be created using vagrant.  
From vm dir execute:
```bash
vagrant up
```
* This command will create a new rocky linux VM and will automatically install on top of it:
  - Python
  - Docker
  - Bazel
  - k3s
  - Helm

* As soon as the machine is up and running we can communicate with the machine via ssh:
```bash
vagrant ssh

# Our project workdir in the VM should be initialized into /app
cd /app
```

### Building the app Docker image:
In order to be able to use our docker in k3s (that is using by default container.d as orchestrator),
we need to make sure that the docker is pushed into registry.  
We want to keep things locally so we will use Docker registry image in order to do so:
1. Build the docker image:
```bash
# In order to run docker without sudo:
sudo usermod -aG docker $USER
newgrp docker

# The build command:
docker build -t nodeapp:1.0.0 .
```

2. Push the docker image into local registry (for k3s):
```bash
# Create local registry on localhost:5000 using registry docker image:
docker run -d -p 5000:5000 --name registry registry:2

# Pushing the image:
docker tag nodeapp:1.0.0 localhost:5000/nodeapp:1.0.0
docker push localhost:5000/nodeapp:1.0.0
```

### Installing MongoDB:
We install MongoDB Using dedicated mongo helm chart:
```bash
# Just in order to make sure the vagrat user will have permissions into the kube config:
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Creating mongo helm:
helm install -n mongo mongo ./mongodb-chart --create-namespace
``` 

### Installing the nodejs app:
After we got the Mongo up and running its time to create the app via helm:
```bash
helm install nodeapp -n myapp ./nice-assignment --create-namespace
```

### Expose the app using ingress controller:
The app should be exposed locally to the machine using nginx ingress controller:
1. Generate ssl_certs:
```bash
python3 ssl_generator.py
```
* This will generate a folder named ssl_certs that should contain 2 files:
  - nginx.crt
  - nginx.key

2. Create the nginx ingress controller using helm:
```bash
helm install nginx-ingress -n nginx-ingress ./nginx-ingress-controller --create-namespace
```

* After the ingress controller is up and running we can validate https communication into the up using a quick curl:
```bash
curl -k https://nice-assignment.local

curl -k https://nice-assignment.local/orders
```

* The application should be served also to the host machine at localhost:8082




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
