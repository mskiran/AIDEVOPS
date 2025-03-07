AI DevOps Project Overview

Project Stages:
Install Jenkins
Create a Simple Pipeline:
Deploy a 3-tier architecture application using the pipeline to a Kubernetes (K8s) server.
Kubernetes Cluster Setup:
Set up a Kubernetes (K8s) cluster before implementing the pipeline. Ensure the cluster is ready for deployment.
Kubernetes Cluster Installation Procedure on Virtual Machine:
Follow the installation guide for setting up the Kubernetes cluster on a virtual machine.
Install Jenkins in a Docker Container:
Follow the installation procedure for setting up Jenkins in a Docker container as outlined in the guide.
Current Status:
The project files in this repository are structured as follows:

/master/master_start.sh:
A script to start the Kubernetes master node.
/node/node_script1.sh:
A script to bring up a Kubernetes worker node.
/nginx_deploy/:
Contains files and configurations for deploying a web service on Kubernetes.
The deployment sequence includes:
Persistent Volumes (PV) and Persistent Volume Claims (PVC).
Kubernetes Deployment and Service objects.
Ensures everything is deployed sequentially.
/ansible/:
Contains the necessary files for configuring and running Ansible to automate tasks and deployments in the project.
Jenkins SCM Script Files (Parent Directory):
script1.sh: A testing script for Jenkins.
script2.sh: A script for invoking Ansible playbooks through Jenkins.
Instructions:
To Set Up Jenkins in a Docker Container:
Follow the steps mentioned in the Jenkins Docker Setup Guide.
https://docs.google.com/document/d/1549Qk0b5EPeznFwGKMTE9Lqh1CcWXYqW/edit?usp=sharing&ouid=114450752232726728905&rtpof=true&sd=true
