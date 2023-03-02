. values

kubectl delete service -n ${POSTGRES_NAMESPACE} postgres

kubectl delete deployment -n ${POSTGRES_NAMESPACE} postgres

kubectl patch pv -n ${POSTGRES_NAMESPACE} postgres-pv-volume -p '{"metadata":{"finalizers":null}}'
kubectl patch pvc -n ${POSTGRES_NAMESPACE} postgres-pv-claim -p '{"metadata":{"finalizers":null}}'
kubectl delete pvc -n ${POSTGRES_NAMESPACE} postgres-pv-claim
kubectl delete pv -n ${POSTGRES_NAMESPACE} postgres-pv-volume

kubectl delete configmap -n ${POSTGRES_NAMESPACE} postgres-config

kubectl delete namespace ${POSTGRES_NAMESPACE}
# kubectl delete namespace postgres-slave
