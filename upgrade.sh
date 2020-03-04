PKG=$1

helm dep up $PKG
helm package $PKG -d docs
helm repo index docs

git add "${PKG}/"
git add docs
