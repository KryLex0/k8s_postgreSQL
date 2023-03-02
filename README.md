# k8s_postgreSQL
Deployment of PostgreSQL 15 in Kubernetes

This is a simple example of how to deploy PostgreSQL 15 in Kubernetes.
This script deploys multiple resources:
- A configmap to store the configuration (`01.postgres-configmap.yaml`)
- A persistent volume claim to store the data (`02.postgres-storage.yaml`)
- A deployment to deploy the PostgreSQL database (`03.postgres-deployment.yaml`)
- A service to expose the PostgreSQL database (`04.postgres-service.yaml`)

## Prerequisites
- Kubernetes cluster
- kubectl

## Deployment
To deploy the PostgreSQL database and all the resources, run the following command:
```
./k8s_postgres_install.sh
```

## Uninstall
To uninstall the PostgreSQL database and all the resources, run the following command:
```
./k8s_postgres_uninstall.sh
```
