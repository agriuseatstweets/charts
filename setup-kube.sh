# Manually:
# Create cluster in UI
# Run:
# gcloud --project $PROJECT compute addresses create $CLUSTER_NAME-ip --region europe-west1

PROJECT=trollhunters
CLUSTER_NAME=hunting
ZONE=europe-west1-b
# STATIC_IP=34.76.183.123

gcloud --project $PROJECT container clusters create $CLUSTER_NAME --num-nodes 3 --machine-type n1-highmem-2 --zone $ZONE

gcloud --project $PROJECT container clusters get-credentials --zone $ZONE $CLUSTER_NAME


# secrets
kubectl create secret generic agrius-logstash-keys --from-file=../dash/logstash/keys
kubectl create secret generic agrius-jaws-keys --from-file=../jaws/keys
kubectl create secret generic agrius-belly-keys --from-file=../bellypy/keys
kubectl create secret generic agrius-bellyback-keys --from-file=../belly/keys
kubectl create secret generic agrius-claws-keys --from-file ../claws/keys
kubectl create secret generic agrius-jaws-envs --from-env-file ../jaws/.env
kubectl create secret generic agrius-claws-envs --from-env-file ../claws/.env
kubectl create secret generic agrius-dig-keys --from-file=../dig/digger/keys


# SSD
kubectl create -f ssd-storage.yaml

# Namespaces
kubectl create namespace cert-manager
kubectl create namespace monitoring

# # Install nginx-ingress
helm install nginx-ingress stable/nginx-ingress --set rbac.create=true

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
