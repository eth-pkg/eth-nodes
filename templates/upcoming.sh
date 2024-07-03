#!/usr/bin/env bash

set -euo pipefail

# Constants
SUPPORTED_CLIENTS=(
  "besu"
  "erigon"
  "geth"
  "lighthouse"
  "lodestar"
  "nethermind"
  "nimbus-eth2"
  "prysm"
  "reth"
  "teku"
)

declare -A REPOSITORIES=(
  ["besu"]="hyperledger/besu"
  ["erigon"]="ledgerwatch/erigon"
  ["geth"]="ethereum/go-ethereum"
  ["lighthouse"]="sigp/lighthouse"
  ["lodestar"]="ChainSafe/lodestar"
  ["nethermind"]="NethermindEth/nethermind"
  ["nimbus-eth2"]="status-im/nimbus-eth2"
  ["prysm"]="prysmaticlabs/prysm"
  ["reth"]="paradigmxyz/reth"
  ["teku"]="ConsenSys/teku"
)

SUPPORTED_ARCHS=("amd64")
SUPPORTED_CODENAMES=("bookworm" "noble")

CLIENT_REVISION=1

# Functions
display_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --client-name <name>          Sets the client name.
  --arch <architecture>         Sets the architecture.
  --codename <codename>         Sets the codename.
  --help, -h                    Displays this help text and exits.
EOF
    exit 0
}

is_supported() {
    local value=$1
    shift
    local array=("$@")
    for item in "${array[@]}"; do
        if [[ "$item" == "$value" ]]; then
            return 0
        fi
    done
    return 1
}

get_latest_release() {
    local owner=$(echo "$1" | cut -d'/' -f1)
    local repo=$(echo "$1" | cut -d'/' -f2)
    local url="https://github.com/$owner/$repo/releases/latest"
    local latest_release=$(curl -I -L -s "$url" | grep -i "location:" | tail -n1 | cut -d ' ' -f2)
    latest_release=$(echo $latest_release | tr -d '\r\n')

    echo "$latest_release"
}

get_hash() {
    local url=$1
    curl -sL "$url" | sha256sum | awk '{print $1}'
}

get_commit_hash_for_tag() {
    local repo=$1
    local tag=$2
    local temp_dir
    temp_dir=$(mktemp -d)
    git clone -q --depth 1 --branch "$tag" "https://github.com/$repo.git" "$temp_dir" > /dev/null 2>&1
    (
        cd "$temp_dir" > /dev/null 2>&1 || { echo "Failed to change directory"; rm -rf "$temp_dir"; return 1; }
        git rev-parse HEAD
    )
    rm -rf "$temp_dir"
}

format_changelog_date() {
    local datetime=$1
    date -d "$datetime" +"%a, %d %b %Y %H:%M:%S %z"
}

replace_in_files() {
    local dir=$1
    local pattern=$2
    local replacement=$3
    echo "pattern: $pattern, replacement: $replacement"

    files=$(find "$dir" -type f -print0 | xargs -0 grep -l "$pattern" 2>/dev/null) || true
    if [ $? -ne 0 ]; then
        echo "No matches found for pattern $pattern. Continuing to next pattern."
        return 0
    fi
  
    for file in $files; do
        echo "Processing file: $file"
        sed -i "s/$pattern/$replacement/g" "$file"
        if [ $? -ne 0 ]; then
            echo "Error: sed failed for file $file with pattern $pattern"
            return 1
        fi
    done
}

HELP=false
CLIENT_NAME=""
CODENAME=""
ARCH="amd64"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --client-name)
            CLIENT_NAME="$2"
            shift 2
            ;;
        --arch)
            ARCH="$2"
            shift 2
            ;;
        --codename)
            CODENAME="$2"
            shift 2
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        *)
            echo "Error: Unknown option $1"
            display_help
            ;;
    esac
done

if [ "$HELP" = true ]; then
    display_help
fi

if ! is_supported "$CLIENT_NAME" "${SUPPORTED_CLIENTS[@]}"; then
    echo "Error: Unsupported client name '$CLIENT_NAME'"
    exit 1
fi

if ! is_supported "$ARCH" "${SUPPORTED_ARCHS[@]}"; then
    echo "Error: Unsupported architecture '$ARCH'"
    exit 1
fi

if ! is_supported "$CODENAME" "${SUPPORTED_CODENAMES[@]}"; then
    echo "Error: Unsupported codename '$CODENAME'"
    exit 1
fi

function main(){
    CLIENT_REPOSITORY=${REPOSITORIES[$CLIENT_NAME]}
    LATEST_RELEASE=$(get_latest_release "$CLIENT_REPOSITORY")
    TAG_NAME=$(echo "$LATEST_RELEASE" | tr '/' '\n' | tail -n1)
    CLIENT_VERSION=$(echo "$TAG_NAME" | sed 's/^v//g')
    RELEASE_DIR="releases/$CODENAME/$ARCH/eth-node-$CLIENT_NAME/$CLIENT_VERSION-$CLIENT_REVISION"
    UPCOMING_DIR="upcoming/$CODENAME/$ARCH/eth-node-$CLIENT_NAME/$CLIENT_VERSION-$CLIENT_REVISION"

    if [ -d "$RELEASE_DIR" ]; then 
    echo "$RELEASE_DIR already exists"
    exit 0
    fi 

    if [ -d "$UPCOMING_DIR" ]; then 
    echo "$UPCOMING_DIR already exists"
    exit 0
    fi 

    CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S %z")
    CHANGELOG_BUILD_DATE=$(format_changelog_date "$CURRENT_DATETIME")
    CHANGELOG_MSG="Support for $CLIENT_VERSION-$CLIENT_REVISION"
    PKG_BUILDER_LATEST_RELEASE=$(get_latest_release "eth-pkg/pkg-builder")
    PKG_BUILDER_TAG_NAME=$(echo "$PKG_BUILDER_LATEST_RELEASE" | tr '/' '\n' | tail -n1)
    PKG_BUILDER_VERSION=$(echo "$PKG_BUILDER_TAG_NAME" | sed 's/^v//g')

    GIT_COMMIT_LONG=$(get_commit_hash_for_tag "$CLIENT_REPOSITORY" "$TAG_NAME")
    GIT_COMMIT_SHORT=${GIT_COMMIT_LONG:0:7}
    TEMPLATE_DIR="templates/$CODENAME/$ARCH/eth-node-$CLIENT_NAME"

    mkdir -p "$UPCOMING_DIR"
    cp -R "$TEMPLATE_DIR"/* "$UPCOMING_DIR"
    CLIENT_PACKAGE_HASH=$(get_hash "$LATEST_RELEASE")

  

    declare -A REPLACEMENTS=(
        ["<CLIENT_VERSION>"]="$CLIENT_VERSION"
        ["<CLIENT_PACKAGE_HASH>"]="$CLIENT_PACKAGE_HASH"
        ["<CLIENT_REVISION>"]="$CLIENT_REVISION"
        ["<CHANGELOG_BUILD_DATE>"]="$CHANGELOG_BUILD_DATE"
        ["<CHANGELOG_MSG>"]="$CHANGELOG_MSG"
        ["<GIT_COMMIT_LONG>"]="$GIT_COMMIT_LONG"
        ["<GIT_COMMIT_SHORT>"]="$GIT_COMMIT_SHORT"
        ["<PKG_BUILDER_VERSION>"]="$PKG_BUILDER_VERSION"
    )

    for key in "${!REPLACEMENTS[@]}"; do
      echo "$key: ${REPLACEMENTS[$key]}"
    done

    for pattern in "${!REPLACEMENTS[@]}"; do
      replace_in_files "$UPCOMING_DIR" "$pattern" "${REPLACEMENTS[$pattern]}"
      if [ $? -ne 0 ]; then
        echo "Error: replacement failed for pattern $pattern"
        continue
      fi
    done
}

main 
