kubectl delete service postgres

kubectl delete deployment postgres

kubectl patch pv postgres-pv-volume -p '{"metadata":{"finalizers":null}}'
kubectl patch pvc postgres-pv-claim -p '{"metadata":{"finalizers":null}}'
kubectl delete pvc postgres-pv-claim
kubectl delete pv postgres-pv-volume

kubectl delete configmap postgres-config