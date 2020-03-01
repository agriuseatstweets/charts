PROJECT=$1
LOCATION=$2
PREFIX=$3
KEY_LOCATION=$4

create () {
  gcloud --project $PROJECT iam service-accounts create $2
  gcloud --project $PROJECT iam service-accounts keys create $KEY_LOCATION/$1.json --iam-account "${2}@${PROJECT}.iam.gserviceaccount.com"
}

create claws "${PREFIX}-agrius-claws"
create jaws "${PREFIX}-agrius-jaws"
create belly "${PREFIX}-agrius-belly"
create dig "${PREFIX}-agrius-dig"

gcloud config set project $PROJECT

bucket() {
  local BKT=gs://$PREFIX-tweets-$1
  gsutil mb -l $LOCATION -p toixotoixo -b on $BKT
}

grant() {
  local BKT=gs://$PREFIX-tweets-$1
  local USER="${2}@${PROJECT}.iam.gserviceaccount.com"

  echo "user:${USER}:projects/${PROJECT}/roles/${3}"
  gsutil iam ch "serviceAccount:${USER}:roles/storage.${3}" $BKT
}

bucket datalake
bucket warehouse

grant datalake "${PREFIX}-agrius-belly" objectAdmin
grant warehouse "${PREFIX}-agrius-dig" legacyBucketOwner
grant warehouse "${PREFIX}-agrius-dig" legacyObjectOwner
grant warehouse "${PREFIX}-agrius-dig" objectCreator
