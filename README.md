# vagrant-helm-maven
Deploying maven app using with helm and vagrant to kubernetes multi node cluster.

## Installing Nexus Repository and Jenkins 
You can go to ./install-dependencies for Jenkins and nexus installation.

## Deploy with helm
This project include 2 way for deployment our simple java application. 
- First one is manuel deploy and you can find deployment : ./deploy-to-k8s/deploy.sh
- Second one is deployment with Jenkins pipeline : ./deploy-to-k8s/Jenkinsfile

- This project does not include unit testing

