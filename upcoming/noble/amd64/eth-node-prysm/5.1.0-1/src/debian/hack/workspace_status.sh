#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "b8cd77945df2b8fa8fe50520df0495309a52c2f3"
echo DATE "2024-08-21 10:18:35+00:00"
echo DATE_UNIX "1724228315"
echo DOCKER_TAG "v5.1.0"
echo STABLE_GIT_TAG "v5.1.0"
