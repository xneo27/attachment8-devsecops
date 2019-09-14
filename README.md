# Millennium Corporation - DevSecOps

## Instructions for Deploying the Solution
To execute builds, add appropriate variables to terraform.tfvars (see variables.tf for a list of mandatory variables), 
then execute build  using

```
sh start.sh
```

This will pull down associated git branches, initialize terraform, then apply terraform.

Terraform and Packer (both from HashiCorp) should be installed in order to deploy

AWS CLI should be installed and configured prior to use.

A Registered domain is expected for the project and should be configured in terraform.tfvars

## Repository Hierarchy List
1.	**attachment8-ingestors** – contains the code used for the data ingestion aspects of the project.
2.	**attachment8-client** – contains the code for the frontend UI for the project.
3.	**attachment8-api** – contains the code for the backend API of the project.
4.	**attachment8-devsecops** – contains the code for the build automation infrastructure setup.
5.	**attachment8-ml** – contains the machine learning (ML) and artificial intelligence (AI) code related to the project.

## Solution Description
We decided to develop a web-based application that was built using the Model-View-ViewModel (MVVM) style architecture. Our application is comprised of both a frontend user interface (UI) and multiple backend APIs. This approach allows us to separate roles into frontend developer and backend developer. Our frontend (UI) is developed using  Vue and our backend is developed using Flask contained within a container hosted on AWS Elastic Container Service (ECS). We are using ElasticSearch as our data store of choice hosted in AWS. Likewise, our machine learning (ML) and artificial intelligence (AI) models are hosted within a container on ECS with an API developed in Flask. 

## Core Technolgoies List
* Vue
* Flask
* Docker
* Terraform
* Jenkins
* ElasticSearch
* Kibana
* Keras
* Tensorflow
* Gensim
* Spacy
* Google TPUs

## Other (Stability, Maintainability, and Scalability)
