#!/usr/bin/env bash
# Run this script from the master branch once your changes are merged.
# It builds the static documentation site using Docker and publishes
# the generated files to the gh-pages branch, which is what GitHub Pages
# serves as the public documentation site.
set -o errexit

DOCKER_HOST_BACKUP=$DOCKER_HOST
unset DOCKER_HOST

cleanup() {
  export DOCKER_HOST=$DOCKER_HOST_BACKUP
}
trap cleanup EXIT

# Build using Docker (compatible with arm64 / Apple Silicon)
docker --context desktop-linux run --rm --platform linux/amd64 \
  -v "$(pwd)":/usr/src/app \
  -w /usr/src/app \
  ruby:2.7 bash -c "
    apt-get update -qq &&
    apt-get install -y -qq nodejs &&
    gem install bundler:1.14.5 --quiet &&
    bundle install --quiet &&
    bundle exec middleman build --clean
  "

# Deploy to gh-pages
commit_title=$(git log -n 1 --format="%s" HEAD)
commit_hash=$(git log -n 1 --format="%H" HEAD)

git symbolic-ref HEAD refs/heads/gh-pages
git --work-tree build reset --mixed --quiet
git --work-tree build add --all

if git --work-tree build diff --exit-code --quiet HEAD --; then
  echo "No changes in build. Nothing to publish."
else
  git --work-tree build commit -m "publish: $commit_title

generated from commit $commit_hash"

  git push upstream gh-pages
  echo "Successfully deployed to gh-pages."
fi

git symbolic-ref HEAD refs/heads/master
git reset --mixed
