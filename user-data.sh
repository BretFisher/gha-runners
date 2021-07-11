#!/bin/bash

#install latest docker 
curl -sSL https://get.docker.com/ | sh

# start a github runner, one container per repo for personal repos
# it needs a PAT to authenticate and then create a runner token
docker run -d --restart always --name github-runner \
  -e RUNNER_SCOPE="repo" \
  -e REPO_URL="https://github.com/bretfisher/gha-runners" \
  -e ACCESS_TOKEN="${github-pat}" \
  -e RUNNER_WORKDIR="/tmp/github-runner" \
  -e LABELS="docker,asg" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp/github-runner:/tmp/github-runner \
  myoung34/github-runner:latest
