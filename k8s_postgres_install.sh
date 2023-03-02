POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgresdb

POSTGRES_STORAGE=5Gi
POSTGRES_IMAGE=postgres:15.2
POSTGRES_PORT=5432

## Creation of configMap
echo 'apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-config
  labels:
    app: postgres
data:
  POSTGRES_DB: '${POSTGRES_DB}'
  POSTGRES_USER: '${POSTGRES_USER}'
  POSTGRES_PASSWORD: '${POSTGRES_DB}  > 01.postgres-configmap.yaml

echo "Applying configMap..."
kubectl apply -f 01.postgres-configmap.yaml
echo "ConfigMap applied successfully!"

## Creation of Persistent Storage Volume & Persistent Volume Claim
echo 'kind: PersistentVolume
apiVersion: v1
metadata:
  name: postgres-pv-volume
  labels:
    type: local
    app: postgres
spec:
  storageClassName: manual
  capacity:
    storage: '${POSTGRES_STORAGE}'
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "/mnt/data"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: postgres-pv-claim
  labels:
    app: postgres
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: '${POSTGRES_STORAGE} > 02.postgres-storage.yaml

echo "Applying Persistent Storage Volume & Persistent Volume Claim..."
kubectl apply -f 02.postgres-storage.yaml
echo "Persistent Storage Volume & Persistent Volume Claim applied successfully!"
kubectl get pvc


## Creation of postgreSQL Deployment
echo 'apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres
          image: '${POSTGRES_IMAGE}'
          imagePullPolicy: "IfNotPresent"
          ports:
            - containerPort: '${POSTGRES_PORT}'
          envFrom:
            - configMapRef:
                name: postgres-config
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: '${POSTGRES_DB}'
      volumes:
        - name: '${POSTGRES_DB}'
          persistentVolumeClaim:
            claimName: postgres-pv-claim' > 03.postgres-deployment.yaml

echo "Applying PostgreSQL Deployment..."
kubectl apply -f 03.postgres-deployment.yaml
echo "PostgreSQL Deployment applied successfully!"

## Creation of PostgreSQL Service
echo 'apiVersion: v1
kind: Service
metadata:
  name: postgres
  labels:
    app: postgres
spec:
  type: NodePort
  ports:
   - port: '${POSTGRES_PORT}'
  selector:
   app: postgres' > 04.postgres-service.yaml

echo "Applying PostgreSQL Service..."
kubectl apply -f 04.postgres-service.yaml
echo "PostgreSQL Service applied successfully!"

kubectl get all


POSTGRES_POD_NAME=$(kubectl get pod -l app=postgres -o jsonpath="{.items[0].metadata.name}")

echo "Waiting for PostgreSQL pod to be ready..."
kubectl wait --for=condition=Ready pod/${POSTGRES_POD_NAME} --timeout=120s
echo "PostgreSQL pod is ready!"

## Connection to PostgreSQL
echo "Do you want to connect to PostgreSQL? (y/n) "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "Connecting to PostgreSQL..."
    echo "kubectl exec -it ${POSTGRES_POD_NAME} --  psql -h localhost -U ${POSTGRES_USER} --password -p ${POSTGRES_PORT} ${POSTGRES_DB}"
    kubectl exec -it ${POSTGRES_POD_NAME} --  psql -h localhost -U ${POSTGRES_USER} --password -p ${POSTGRES_PORT} ${POSTGRES_DB}
else
    echo "Exiting..."
    exit 0
fi