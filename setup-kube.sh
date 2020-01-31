
# Manually:
# Create cluster in UI
# Run:
# gcloud --project $PROJECT compute addresses create $CLUSTER_NAME-ip --region europe-west1

# PROJECT=toixotoixo
# CLUSTER_NAME=toixo-cluster
# STATIC_IP=34.76.183.123

# # gcloud container clusters create my-regional-cluster --num-nodes 2 --region europe-west1 \
# # --node-locations europe-west1-b,europe-west1-c

# gcloud --project $PROJECT container clusters get-credentials --region europe-west1 $CLUSTER_NAME


# secrets
# kubectl create secret generic agrius-logstash-keys --from-file=../dash/logstash/keys
# kubectl create secret generic agrius-jaws-keys --from-file=../jaws/keys
# kubectl create secret generic agrius-belly-keys --from-file=../bellypy/keys
# kubectl create secret generic agrius-bellyback-keys --from-file=../belly/keys
# kubectl create secret generic agrius-claws-keys --from-file ../claws/keys
# kubectl create secret generic agrius-jaws-envs --from-env-file ../jaws/.env
# kubectl create secret generic agrius-claws-envs --from-env-file ../claws/.env


# SSD
# kubectl create -f ssd-storage.yaml


# # Install nginx-ingress
# helm install nginx-ingress stable/nginx-ingress --set rbac.create=true

## Install cert-manager
# kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/v0.13.0/deploy/manifests/00-crds.yaml

# kubectl create namespace cert-manager
# helm repo add jetstack https://charts.jetstack.io
# helm repo update

# helm install cert-manager --namespace cert-manager \
  # --version v0.13.0 \
  # jetstack/cert-manager

# wait for it to be ready
# sleep 15

# # Create cluster-issuer
# kubectl create -f cm-issuer.yaml
