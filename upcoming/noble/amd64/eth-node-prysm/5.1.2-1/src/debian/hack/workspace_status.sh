#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "944f94a9bf6cbd19699b319917499fd7262e2f73"
echo DATE "2024-10-17 08:12:40+00:00"
echo DATE_UNIX "1729127560"
echo DOCKER_TAG "v5.1.2"
echo STABLE_GIT_TAG "v5.1.2"
