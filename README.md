
AI DevOps Project Overview
Project Stages:
1.	Install Jenkins
2.	Create a Simple Pipeline: 
o	Deploy a 3-tier architecture application using the pipeline to a Kubernetes (K8s) server.
3.	Kubernetes Cluster Setup: 
o	Set up a Kubernetes (K8s) cluster before implementing the pipeline. Ensure the cluster is ready for deployment.
4.	Kubernetes Cluster Installation Procedure on Virtual Machine: 
o	Follow the installation guide for setting up the Kubernetes cluster on a virtual machine.
5.	Install Jenkins in a Docker Container: 
o	Follow the installation procedure for setting up Jenkins in a Docker container as outlined in the guide.
________________________________________
Current Status:
The project files in this repository are structured as follows:
1.	/master/master_start.sh: 
o	A script to start the Kubernetes master node.
2.	/node/node_script1.sh: 
o	A script to bring up a Kubernetes worker node.
3.	/nginx_deploy/: 
o	Contains files and configurations for deploying a web service on Kubernetes.
o	The deployment sequence includes: 
	Persistent Volumes (PV) and Persistent Volume Claims (PVC).
	Kubernetes Deployment and Service objects.
	Ensures everything is deployed sequentially.
4.	/ansible/: 
o	Contains the necessary files for configuring and running Ansible to automate tasks and deployments in the project.
5.	Jenkins SCM Script Files (Parent Directory): 
o	script1.sh: A testing script for Jenkins.
o	script2.sh: A script for invoking Ansible playbooks through Jenkins.
________________________________________
Instructions:
To Set Up Jenkins in a Docker Container:
Follow the steps mentioned in the Jenkins Docker Setup Guide.

https://docs.google.com/document/d/1549Qk0b5EPeznFwGKMTE9Lqh1CcWXYqW/edit?usp=sharing&ouid=114450752232726728905&rtpof=true&sd=true

