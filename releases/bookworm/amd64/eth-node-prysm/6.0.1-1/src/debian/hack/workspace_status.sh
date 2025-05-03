#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "204302a821da57632ec4e2d89126a21f00bd2817"
echo DATE "2025-05-03 06:51:15+00:00"
echo DATE_UNIX "1746247875"
echo DOCKER_TAG "v6.0.1"
echo STABLE_GIT_TAG "v6.0.1"
