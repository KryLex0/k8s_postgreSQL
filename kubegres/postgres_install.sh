. values

# Installing Kubegres Operator in namespace kubegres-system
kubectl apply -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.16/kubegres.yaml

echo "Creation of namespace: ${POSTGRES_NAMESPACE}..."
kubectl create namespace ${POSTGRES_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

echo "apiVersion: v1
kind: Secret
metadata:
  name: ${POSTGRES_SECRET_NAME}
  namespace: ${POSTGRES_NAMESPACE}
type: Opaque
stringData:
  superUserPassword: ${POSTGRES_MASTER_PASSWORD}
  replicationUserPassword: ${POSTGRES_REPLICATION_PASSWORD}" > 01.postgres-secret.yaml

echo "Creating secret..."
kubectl apply -f 01.postgres-secret.yaml
echo "Secret created!"


echo "apiVersion: kubegres.reactive-tech.io/v1
kind: Kubegres
metadata:
  name: mypostgres
  namespace: ${POSTGRES_NAMESPACE}

spec:

   replicas: ${POSTGRES_REPLICAS}
   image: ${POSTGRES_IMAGE}

   database:
      size: 200Mi

   env:
      - name: POSTGRES_PASSWORD
        valueFrom:
           secretKeyRef:
              name: ${POSTGRES_SECRET_NAME}
              key: superUserPassword

      - name: POSTGRES_REPLICATION_PASSWORD
        valueFrom:
           secretKeyRef:
              name: ${POSTGRES_SECRET_NAME}
              key: replicationUserPassword" > 02.postgres.yaml

echo "Creating PostgreSQL..."
kubectl apply -f 02.postgres.yaml
echo "PostgreSQL created!"


echo "Clusters and all pods are being created and will be ready in a few minutes."


## Wait for all pods to be ready

# echo "Waiting for all PostgreSQL pods to be ready..."
# sleep 10
# for (( c=0; c<$POSTGRES_REPLICAS; c++ ));do
#     echo 'kubectl get pod -n '${POSTGRES_NAMESPACE} ' -l app=mypostgres -o jsonpath="{.items['$c'].metadata.name}"'
#     POSTGRES_POD_NAME=$(kubectl get pod -n ${POSTGRES_NAMESPACE} -l app=mypostgres -o jsonpath="{.items[$c].metadata.name}")
#     echo "Waiting for pod ${POSTGRES_POD_NAME} to be ready..."
#     kubectl wait -n ${POSTGRES_NAMESPACE} --for=condition=Ready pod/${POSTGRES_POD_NAME} --timeout=120s
#     if [ $? -eq 0 ]; then
#         echo "Pod ${POSTGRES_POD_NAME} ready!"
#     fi
#     sleep 5

# done
# echo "All pods are ready!"
# echo "PostgreSQL installed successfully!"


