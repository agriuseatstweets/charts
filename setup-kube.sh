# Manually:
# Create cluster in UI
# Run:
# gcloud --project $PROJECT compute addresses create $CLUSTER_NAME-ip --region europe-west1

PROJECT=toixotoixo
CLUSTER_NAME=toixo
ZONE=europe-west1-b
PREFIX=corona
# STATIC_IP=34.76.183.123

# gcloud --project $PROJECT container clusters create $CLUSTER_NAME --num-nodes 3 --machine-type n1-highmem-2 --zone $ZONE

gcloud --project $PROJECT container clusters get-credentials --zone $ZONE $CLUSTER_NAME

# SSD
kubectl create -f ssd-storage.yaml

# Namespaces
kubectl create namespace cert-manager
kubectl create namespace routing
kubectl create namespace monitoring

# # Install nginx-ingress
helm install -n routing nginx-ingress stable/nginx-ingress --set rbac.create=true

## Install cert-manager
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/v0.13.0/deploy/manifests/00-crds.yaml

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install cert-manager --namespace cert-manager \
  --version v0.13.0 \
  jetstack/cert-manager

# wait for it to be ready
sleep 30

# Create cluster-issuer
kubectl create -f cm-issuer.yaml

# Create Prometheus Operator
helm install --namespace monitoring prometheus stable/prometheus-operator -f values/prometheus.yaml

# Create zookeeper operator and kafka operator
helm install zookeeper-operator banzaicloud-stable/zookeeper-operator
helm install kafka-operator banzaicloud-stable/kafka-operator

# wait for kafka-operator to be ready and make kafka/zk cluster
sleep 30
kubectl apply -f ./kafka-operator/prod

# wait for cluster and install exporter 
sleep 30
helm install kafka-exporter kafka-exporter -f ./kafka-operator/exporter-values.yaml
