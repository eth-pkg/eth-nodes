#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "eafef8c7c803f5a63755a9a63377c3bd6459aa41"
echo DATE "2025-05-22 08:38:07+00:00"
echo DATE_UNIX "1747895887"
echo DOCKER_TAG "v6.0.3"
echo STABLE_GIT_TAG "v6.0.3"
