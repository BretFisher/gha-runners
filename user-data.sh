#!/bin/bash

# install latest docker 
# export $VERSION to manually set the version of docker you want to install
# export $VERSION=20.10.5
curl -sSL https://get.docker.com/ | sh

# RUNNER: SINGLE REPO MODE
#   https://github.com/myoung34/docker-github-actions-runner
# start a single github runner per EC2 instance in single-repo mode
# it will use the GitHub PAT to create a runner token on startup
#
docker run -d --restart always --name github-runner \
  -e RUNNER_SCOPE="repo" \
  -e REPO_URL="https://github.com/${github-repo}" \
  -e ACCESS_TOKEN="${github-token}" \
  -e RUNNER_WORKDIR="/tmp/github-runner" \
  -e LABELS="${github-runner-labels}" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp/github-runner:/tmp/github-runner \
  myoung34/github-runner:latest


# RUNNER: ORG MODE
#   https://github.com/myoung34/docker-github-actions-runner
# start a single github runner per EC2 instance in org-wide mode
# it will use the GitHub PAT to create a runner token on startup
#
# docker run -d --restart always --name github-runner \
#   -e RUNNER_SCOPE="org" \
#   -e ORG_NAME="${github-org}" \
#   -e ACCESS_TOKEN="${github-token}" \
#   -e RUNNER_WORKDIR="/tmp/github-runner" \
#   -e LABELS="${github-runner-labels}" \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   -v /tmp/github-runner:/tmp/github-runner \
#   myoung34/github-runner:latest


# if you wanted to run multiple runners per instance, you could do that here by copying
# the docker command above and changing the REPO_URL, RUNNER_WORKDIR, and volume paths