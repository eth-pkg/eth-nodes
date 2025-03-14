#!/bin/bash

# action_env through bazel does not work https://github.com/bazelbuild/bazel/issues/8578
# providing env variables also does not work
# patching each update is not feasible on each update, neither automatable

echo STABLE_GIT_COMMIT "863eee7b40618e3af4cfff955a78b3cc66d63f9e"
echo DATE "2025-03-14 11:25:37+00:00"
echo DATE_UNIX "1741947937"
echo DOCKER_TAG "v5.3.1"
echo STABLE_GIT_TAG "v5.3.1"
