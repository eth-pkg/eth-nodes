#! /usr/bin/env bash 

set -e 

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

declare -A repositories
repositories=(
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


SUPPORTED_ARCHS=(
  "amd64"
)

SUPPORTED_CODENAMES=(
  "bookworm"
  "noble"
)

# VARIABLES to replace 
CLIENT_REVISION=1

display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --client-name <name>          Sets the client name."
    echo "  --arch <architecture>         Sets the architecture."
    echo "  --codename <codename>         Sets the codename."
    echo "  --help, -h                    Displays this help text and exits."
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


HELP=false
CLIENT_NAME=""
CODENAME=""
ARCH=""

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

# Check if client name is supported
if ! is_supported "$CLIENT_NAME" "${SUPPORTED_CLIENTS[@]}"; then
    echo "Error: Unsupported client name '$CLIENT_NAME'. Supported client names are: ${SUPPORTED_CLIENTS[*]}"
    exit 1
fi

# Check if architecture is supported
if ! is_supported "$ARCH" "${SUPPORTED_ARCHS[@]}"; then
    echo "Error: Unsupported architecture '$ARCH'. Supported architectures are: ${SUPPORTED_ARCHS[*]}"
    exit 1
fi

# Check if codename is supported
if ! is_supported "$CODENAME" "${SUPPORTED_CODENAMES[@]}"; then
    echo "Error: Unsupported codename '$CODENAME'. Supported codenames are: ${SUPPORTED_CODENAMES[*]}"
    exit 1
fi

get_repository_url() {
    local repo_name=$1
    echo "${repositories[$repo_name]}"
}

CLIENT_REPOSITORY=$(get_repository_url "$CLIENT_NAME")
TEMPLATE_DIR="templates/bookworm/amd64/eth-node-$CLIENT_NAME"
REPOSITORY_URL="git@github.com:$CLIENT_REPOSITORY.git"


get_latest_release() {
    local owner=$(echo "$1" | cut -d'/' -f1)
    local repo=$(echo "$1" | cut -d'/' -f2)
    local url="https://github.com/$owner/$repo/releases/latest"
    local latest_release=$(curl -I -L -s "$url" | grep -i "location:" | tail -n1 | cut -d ' ' -f2)
    latest_release=$(echo $latest_release | tr -d '\r\n')

    echo "$latest_release"
}

get_hash() {
  local latest_release="$1"
  local tmp_dir
  local download_url
  local downloaded_file
  local hash

  tmp_dir=$(mktemp -d) || { echo "Failed to create temporary directory"; return 1; }

  download_url=$(echo "$latest_release" | sed 's/releases/archives/' | sed 's/tag/tags/')
  download_url="${download_url}.tar.gz"

  cd "$tmp_dir" || { echo "Failed to change directory to temporary directory"; return 1; }
  wget -q "$download_url" -O downloaded_file || { echo "Failed to download file"; return 1; }

  # Calculate the hash
  hash=$(sha256sum downloaded_file | awk '{ print $1 }') || { echo "Failed to calculate hash"; return 1; }

  # Clean up
  rm downloaded_file
  cd - > /dev/null
  rm -r "$tmp_dir"

  # Return the hash
  echo "$hash"
}

get_commit_hash_for_tag() {
    local repo_url=$1
    local tag_name=$2

    local temp_dir=$(mktemp -d)

    git clone --depth 1 --branch "$tag_name" "$repo_url" "$temp_dir" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Failed to clone repository"
        rm -rf "$temp_dir"
        return 1
    fi

    cd "$temp_dir" || { echo "Failed to change directory"; rm -rf "$temp_dir"; return 1; }

    local commit_hash=$(git rev-parse HEAD)

    cd - > /dev/null
    rm -rf "$temp_dir"

    echo "$commit_hash"
}

format_changelog_date() {
    local datetime=$1
    echo $(date -d "$datetime" +"%a, %d %b %Y %H:%M:%S %z")
}

latest_release=$(get_latest_release $CLIENT_REPOSITORY)
tag_name=$(echo "$latest_release" | tr '/' '\n' | tail -n1)
CLIENT_VERSION=$(echo "$tag_name" | sed 's/^v//g')
release_dir="releases/$CODENAME/$ARCH/eth-node-$CLIENT_NAME/$CLIENT_VERSION-$CLIENT_REVISION"
upcoming_dir="upcoming/$CODENAME/$ARCH/eth-node-$CLIENT_NAME/$CLIENT_VERSION-$CLIENT_REVISION"


if [ -d "$release_dir" ]; then 
  echo "$release_dir already exist"
  exit 0
fi 
if [ -d "$upcoming_dir" ]; then 
  echo "$upcoming_dir already exist"
  exit 0
fi 


current_datetime=$(date +"%Y-%m-%d %H:%M:%S %z")
echo $current_datetime
CHANGELOG_BUILD_DATE=$(format_changelog_date "$current_datetime")
CHANGELOG_MSG="Support for $CLIENT_VERSION-$CLIENT_REVISION"
PKG_BUILDER_VERSION="0.2.5"
GIT_COMMIT_LONG=$(get_commit_hash_for_tag $REPOSITORY_URL $tag_name)
GIT_COMMIT_SHORT=${GIT_COMMIT_LONG:0:7}

mkdir -p $upcoming_dir
cp -R $TEMPLATE_DIR/* $upcoming_dir
CLIENT_PACKAGE_HASH=$(get_hash $latest_release)


declare -A replacements
replacements=(
    ["<CLIENT_VERSION>"]="$CLIENT_VERSION"
    ["<CLIENT_PACKAGE_HASH>"]="$CLIENT_PACKAGE_HASH"
    ["<CLIENT_REVISION>"]="$CLIENT_REVISION"
    ["<CHANGELOG_BUILD_DATE>"]="$CHANGELOG_BUILD_DATE"
    ["<CHANGELOG_MSG>"]="$CHANGELOG_MSG"
    ["<GIT_COMMIT_LONG>"]="$GIT_COMMIT_LONG"
    ["<GIT_COMMIT_SHORT>"]="$GIT_COMMIT_SHORT"
    ["<PKG_BUILDER_VERSION>"]="$PKG_BUILDER_VERSION"
)

for pattern in "${!replacements[@]}"; do
    grep -rl "$pattern" "$upcoming_dir" | while read -r file; do
        sed -i "s/$pattern/${replacements[$pattern]}/g" "$file"
    done
done
