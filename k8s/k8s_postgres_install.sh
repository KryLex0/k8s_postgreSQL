. values


# for i in 1
# do
#   if [ $i -eq 1 ]; then
#       POSTGRES_NAMESPACE=postgres-master
#       echo "PostgreSQL namespace: ${POSTGRES_NAMESPACE}"
#   else
#       POSTGRES_NAMESPACE=postgres-slave
#       echo "PostgreSQL namespace: ${POSTGRES_NAMESPACE}"
#   fi

echo "Creation of namespace: ${POSTGRES_NAMESPACE}..."
kubectl create namespace ${POSTGRES_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -


echo "Installing PostgreSQL in namespace: ${POSTGRES_NAMESPACE}..."

## Creation of configMap
echo '## Creation of configMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-config
  namespace: '${POSTGRES_NAMESPACE}'
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
echo '## Creation of Persistent Storage Volume & Persistent Volume Claim
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv-volume
  namespace: '${POSTGRES_NAMESPACE}'
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
  namespace: '${POSTGRES_NAMESPACE}'
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
echo '## Creation of postgreSQL Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: '${POSTGRES_NAMESPACE}'
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
echo '## Creation of PostgreSQL Service
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: '${POSTGRES_NAMESPACE}'
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










POSTGRES_POD_NAME=$(kubectl get pod -n ${POSTGRES_NAMESPACE} -l app=postgres -o jsonpath="{.items[0].metadata.name}")

echo "Waiting for PostgreSQL pod to be ready..."
kubectl wait -n ${POSTGRES_NAMESPACE} --for=condition=Ready pod/${POSTGRES_POD_NAME} --timeout=120s
echo "PostgreSQL pod is ready!"

echo "PostgreSQL files are located in /var/lib/postgresql/data"

## Connection to PostgreSQL
echo "Do you want to enter the PostgreSQL pod? (y/n) "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    # kubectl exec -it -n ${POSTGRES_NAMESPACE} pod/${POSTGRES_POD_NAME} --  psql -h localhost -U ${POSTGRES_USER} --password -p ${POSTGRES_PORT} ${POSTGRES_DB}
    echo "Connecting to PostgreSQL in namespace ${POSTGRES_NAMESPACE}..."
    echo "kubectl exec -it -n ${POSTGRES_NAMESPACE} pod/${POSTGRES_POD_NAME} -- bash"
    kubectl exec -it -n ${POSTGRES_NAMESPACE} pod/${POSTGRES_POD_NAME} -- bash
else
    echo "Exiting..."
    exit 0
fi