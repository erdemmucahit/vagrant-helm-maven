#! /bin/bash

NEXUS_IP=10.0.0.11

cd /tmp
git clone https://github.com/jenkins-docs/simple-java-maven-app.git
cat <<EOF | sudo /tmp/simple-java-maven-app/Dockerfile
{
	FROM openjdk:8-alpine
	ARG APPLICATION
	ADD target/$APPLICATION*.jar /service/service.jar
	EXPOSE 8080
	ENTRYPOINT java -Djava.security.egd=file:/dev/./urandom $JAVA_OPTS  -jar /service/service.jar
}
EOF

docker build -t simple-java-maven-app:1.0 .

docker login $NEXUS_IP -u username -p  password

docker  push $NEXUS_IP:8081/simple-java-maven-app:1.0

#installing helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

helm create simple-maven-app

##simple-maven-app /
##  Chart.yaml
##  values.yaml
##  templates /
##  charts /
##  .helmignore

sudo rm -r /tmp/simple-java-maven-app/simple-maven-app/templates/deployment.yaml
cat <<EOF | sudo /tmp/simple-java-maven-app/simple-maven-app/templates/deployment.yaml
{
	apiVersion: apps/v1
	kind: Deployment
	metadata:
	  name: simple-java-maven-app-1.0
	spec:
	  selector:
		matchLabels:
		  app: simple-java-maven-app
		  version: "1.0"
	  replicas: 1
	  strategy:
		rollingUpdate:
		  maxSurge: 100%
		  maxUnavailable: 0
		type: RollingUpdate
	  template:
		metadata:
		  labels:
			app: simple-java-maven-app-deployment
			version: "1.0"
		spec:
		  terminationGracePeriodSeconds: 90
		  containers:
			- name: simple-java-maven-app-deployment
			  image: ${NEXUS_IP}/simple-java-maven-app:1.0
			  env:
				- name: SERVER_PORT
				  value: "8080"
}
EOF

sudo rm -r /tmp/simple-java-maven-app/simple-maven-app/templates/service.yaml
cat <<EOF | sudo /tmp/simple-java-maven-app/simple-maven-app/templates/service.yaml
{
	apiVersion: v1
	kind: Service
	metadata:
	  name: simple-java-maven-app-service
	spec:
	  selector:
		app: simple-java-maven-app-deployment
		version: "1.0"
	  ports:
	  - protocol: TCP
		name: http
		port: 8080
		targetPort: 8080
	  type: NodePort
}
EOF

sudo rm -r /tmp/simple-java-maven-app/simple-maven-app/Chart.yaml
cat <<EOF | sudo /tmp/simple-java-maven-app/simple-maven-app/Charts.yaml
{
	apiVersion: v2
	name: helm-kubernetes-local
	description: A Helm chart for Kubernetes
	type: application
	version: 1.0
	appVersion: 1.0-SNAPSHOT
}
EOF

sudo rm -r /tmp/simple-java-maven-app/simple-maven-app/values.yaml
cat <<EOF | sudo /tmp/simple-java-maven-app/simple-maven-app/values.yaml
{
	image:
	  repository: $NEXUS_IP:8081/simple-java-maven-app
	  pullPolicy: Always
	  # Overrides the image tag whose default is the chart appVersion.
	  tag: "1.0"
	  branch: ""
}
EOF

helm install  --name simple-maven-app .