#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "ac1717f1e44bd218b0bd3af0c4dec951c075f462"
echo DATE "2024-12-17 12:35:54+00:00"
echo DATE_UNIX "1734435354"
echo DOCKER_TAG "v5.2.0"
echo STABLE_GIT_TAG "v5.2.0"
