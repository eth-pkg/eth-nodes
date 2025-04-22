#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "a0071826c5daf7dc3a6e76874fdaa76481a3c665"
echo DATE "2025-04-22 06:02:38+00:00"
echo DATE_UNIX "1745294558"
echo DOCKER_TAG "v6.0.0"
echo STABLE_GIT_TAG "v6.0.0"
