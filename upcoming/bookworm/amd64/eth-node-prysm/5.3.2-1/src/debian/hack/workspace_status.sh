#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "21e1f7883b88ce39d16263d1cdea70bfdaa4d359"
echo DATE "2025-04-09 18:43:18+00:00"
echo DATE_UNIX "1744216998"
echo DOCKER_TAG "v5.3.2"
echo STABLE_GIT_TAG "v5.3.2"
