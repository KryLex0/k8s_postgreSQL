. values

kubectl delete -f https://raw.githubusercontent.com/reactive-tech/kubegres/v1.16/kubegres.yaml

for (( c=1; c<=$POSTGRES_REPLICAS; c++ ))
do
    echo "Deleting PostgreSQL instance: $c..."
    POSTGRES_PVC_NAME=postgres-db-mypostgres-$c-0

    POSTGRES_PV_NAME=$(kubectl get pv -n ${POSTGRES_NAMESPACE} -o jsonpath="{.items[0].metadata.name}")
    echo "PV name: ${POSTGRES_PV_NAME}"

    kubectl patch pv -n ${POSTGRES_NAMESPACE} ${POSTGRES_PV_NAME} -p '{"metadata":{"finalizers":null}}'
    kubectl patch pvc -n ${POSTGRES_NAMESPACE} ${POSTGRES_PVC_NAME} -p '{"metadata":{"finalizers":null}}'
    kubectl delete pvc -n ${POSTGRES_NAMESPACE} ${POSTGRES_PVC_NAME}
    kubectl delete pv -n ${POSTGRES_NAMESPACE} ${POSTGRES_PV_NAME}

done



