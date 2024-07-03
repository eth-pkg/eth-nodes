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

get_download_url() {
  local latest_release="$1"
  local download_url

  # Rewrite the download URL
  download_url=$(echo "$latest_release" | sed 's/releases/archive\/refs/' | sed 's/tag/tags/')
  download_url="${download_url}.tar.gz"

  echo "$download_url"
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

get_submodules_for_tag() {
    local repo=$1
    local tag=$2
    local temp_dir
    temp_dir=$(mktemp -d)
    git clone -q --depth 1 --branch "$tag" "https://github.com/$repo.git" "$temp_dir" > /dev/null 2>&1
    (
        cd "$temp_dir" > /dev/null 2>&1 || { echo "Failed to change directory"; rm -rf "$temp_dir"; return 1; }

        output="["

        while read -r line; do
        commit_hash=$(echo $line | awk '{print $1}' | tr -d '-')
        submodule_path=$(echo $line | awk '{print $2}')
        
        output="${output}
        { \"commit\" = \"$commit_hash\", \"path\" = \"$submodule_path\" },"
        done < <(git submodule status)

        output="${output%,}
        ]"

        echo "$output"

   
    )
    rm -rf "$temp_dir"
}

format_changelog_date() {
    local datetime=$1
    date -d "$datetime" +"%a, %d %b %Y %H:%M:%S %z"
}

format_build_date() {
    local datetime=$1
    date -d "$datetime" +"%Y-%m-%dT%H:%MZ"
}

format_date() {
    local datetime=$1
    date -d "$datetime" +"%Y-%m-%d %H:%M:%S+00:00"
}

format_unix_timestamp() {
    local datetime=$1
    date -d "$datetime" +%s
}

replace_in_files() {
    local dir=$1
    local pattern=$2
    local replacement=$3
    echo "pattern: $pattern, replacement: $replacement"
    
    local temp_file=$(mktemp)
    echo "$replacement" > "$temp_file"

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

replace_git_submodules_in_file() {
    local file=$1
    local pattern=$2
    local replacement=$3
    echo "pattern: $pattern, replacement: $replacement"

    # Escape special characters in the pattern for awk
    escaped_pattern=$(echo "$pattern" | sed 's/[][\\.^$*]/\\&/g')

    # Perform the replacement using awk
    awk -v pattern="$escaped_pattern" -v replacement="submodules = $replacement" '
        BEGIN { found = 0 }
        {
            if ($0 ~ pattern && !found) {
                print replacement
                found = 1
            } else {
                print $0
            }
        }
    ' "$file" > tmp && mv tmp "$file"

    if [ $? -ne 0 ]; then
        echo "Error: awk failed for file $file with pattern $pattern"
        return 1
    fi
}

function main(){
    CLIENT_REPOSITORY=${REPOSITORIES[$CLIENT_NAME]}
    LATEST_RELEASE=$(get_latest_release "$CLIENT_REPOSITORY")
    TAG_NAME=$(echo "$LATEST_RELEASE" | tr '/' '\n' | tail -n1)
    CLIENT_VERSION=$(echo "$TAG_NAME" | sed 's/^v//g')
    RELEASE_DIR="releases/$CODENAME/$ARCH/eth-node-$CLIENT_NAME/$CLIENT_VERSION-$CLIENT_REVISION"
    UPCOMING_DIR="upcoming/$CODENAME/$ARCH/eth-node-$CLIENT_NAME/$CLIENT_VERSION-$CLIENT_REVISION"

    #if [ -d "$RELEASE_DIR" ]; then 
    #  echo "$RELEASE_DIR already exists"
    #  exit 0
    #fi 

    if [ -d "$UPCOMING_DIR" ]; then 
      echo "$UPCOMING_DIR already exists"
      exit 0
    fi

    CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S %z")
    CHANGELOG_BUILD_DATE=$(format_changelog_date "$CURRENT_DATETIME")
    BUILD_DATE=$(format_build_date "$CURRENT_DATETIME")
    BUILD_DATE_UTC=$(format_date "$CURRENT_DATETIME")
    BUILD_DATE_UNIX_TIMESTAMP=$(format_unix_timestamp "$CURRENT_DATETIME")

    CHANGELOG_MSG="Support for $CLIENT_VERSION-$CLIENT_REVISION"
    PKG_BUILDER_LATEST_RELEASE=$(get_latest_release "eth-pkg/pkg-builder")
    PKG_BUILDER_TAG_NAME=$(echo "$PKG_BUILDER_LATEST_RELEASE" | tr '/' '\n' | tail -n1)
    PKG_BUILDER_VERSION=$(echo "$PKG_BUILDER_TAG_NAME" | sed 's/^v//g')

    GIT_COMMIT_LONG=$(get_commit_hash_for_tag "$CLIENT_REPOSITORY" "$TAG_NAME")
    GIT_COMMIT_SHORT=${GIT_COMMIT_LONG:0:7}
    TEMPLATE_DIR="templates/$CODENAME/$ARCH/eth-node-$CLIENT_NAME"

    mkdir -p "$UPCOMING_DIR"
    cp -R "$TEMPLATE_DIR"/* "$UPCOMING_DIR"
    DOWNLOAD_URL=$(get_download_url "$LATEST_RELEASE" )
    CLIENT_PACKAGE_HASH=$(get_hash "$DOWNLOAD_URL")

    if [ "$CLIENT_NAME" = "nimbus-eth2" ];then 
      GIT_SUBMODULES=$(get_submodules_for_tag "$CLIENT_REPOSITORY" "$TAG_NAME")
      VERSION_MAJOR=$(echo "$CLIENT_VERSION" | cut -d '.' -f 1)
      VERSION_MINOR=$(echo "$CLIENT_VERSION" | cut -d '.' -f 2)
      VERSION_BUILD=$(echo "$CLIENT_VERSION" | cut -d '.' -f 3)
      replace_git_submodules_in_file "$UPCOMING_DIR/pkg-builder.toml" "<GIT_SUBMODULES>" "$GIT_SUBMODULES"
    fi 

    declare -A REPLACEMENTS=(
        ["<CLIENT_VERSION>"]="$CLIENT_VERSION"
        ["<CLIENT_PACKAGE_HASH>"]="$CLIENT_PACKAGE_HASH"
        ["<CLIENT_REVISION>"]="$CLIENT_REVISION"
        ["<CHANGELOG_BUILD_DATE>"]="$CHANGELOG_BUILD_DATE"
        ["<CHANGELOG_MSG>"]="$CHANGELOG_MSG"
        ["<GIT_COMMIT_LONG>"]="$GIT_COMMIT_LONG"
        ["<GIT_COMMIT_SHORT>"]="$GIT_COMMIT_SHORT"
        ["<PKG_BUILDER_VERSION>"]="$PKG_BUILDER_VERSION"
        ["<BUILD_DATE>"]="$BUILD_DATE"
        ["<BUILD_DATE_UTC>"]="$BUILD_DATE_UTC"
        ["<BUILD_DATE_UNIX_TIMESTAMP>"]="$BUILD_DATE_UNIX_TIMESTAMP"
        ["<VERSION_MAJOR>"]="$VERSION_MAJOR"
        ["<VERSION_MINOR>"]="$VERSION_MINOR"
        ["<VERSION_BUILD>"]="$VERSION_BUILD"
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
