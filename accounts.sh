PROJECT=$1
LOCATION=$2
PREFIX=$3
NAMESPACE=$4
KEY_LOCATION=$5

create () {
  gcloud --project $PROJECT iam service-accounts create $2
  gcloud --project $PROJECT iam service-accounts keys create $KEY_LOCATION/$1.json --iam-account "${2}@${PROJECT}.iam.gserviceaccount.com"
}

bucket() {
  local BKT=gs://$PREFIX-tweets-$1
  gsutil mb -l $LOCATION -p toixotoixo -b on $BKT
}

grant() {
  local BKT=gs://$PREFIX-tweets-$1
  local USER="${2}@${PROJECT}.iam.gserviceaccount.com"

  gsutil iam ch "serviceAccount:${USER}:roles/storage.${3}" $BKT
}

mkdir $KEY_LOCATION/$PREFIX

create claws "${PREFIX}-agrius-claws"
create jaws "${PREFIX}-agrius-jaws"
create belly "${PREFIX}-agrius-belly"
create dig "${PREFIX}-agrius-dig"

gcloud config set project $PROJECT

bucket datalake
bucket warehouse

grant datalake "${PREFIX}-agrius-belly" objectAdmin
grant warehouse "${PREFIX}-agrius-dig" legacyBucketOwner
grant warehouse "${PREFIX}-agrius-dig" legacyObjectOwner
grant warehouse "${PREFIX}-agrius-dig" objectCreator

# secrets
kubectl -n $NAMESPACE create secret generic $PREFIX-agrius-jaws-keys --from-file=./keys/$PREFIX/jaws
kubectl -n $NAMESPACE create secret generic $PREFIX-agrius-belly-keys --from-file=./keys/$PREFIX/belly
kubectl -n $NAMESPACE create secret generic $PREFIX-agrius-claws-keys --from-file ./keys/$PREFIX/claws
kubectl -n $NAMESPACE create secret generic $PREFIX-agrius-dig-keys --from-file=./keys/$PREFIX/dig
kubectl -n $NAMESPACE create secret generic $PREFIX-agrius-jaws-envs --from-env-file ../jaws/.env
kubectl -n $NAMESPACE create secret generic $PREFIX-agrius-claws-envs --from-env-file ../claws/.env
# kubectl -n $NAMESPACE create secret generic agrius-logstash-keys --from-file=../dash/logstash/keys
