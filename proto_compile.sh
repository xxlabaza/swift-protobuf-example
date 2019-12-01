#!/bin/sh

set -e


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function log () {
  local TIME=$(date +'%Y-%m-%d %H:%M:%S')
  local MESSAGE="${1}"
  echo "${TIME}\t- ${MESSAGE}"
}

function compile_protobuf_file () {
  local FILE_PATH="${1}"
  local PROTO_PATH="${FILE_PATH%/*}"
  local SWIFT_OUTPUT="${PROTO_PATH%/*}"
  log "compiling proto file:\n${FILE_PATH}"
  protoc \
      --proto_path="${PROTO_PATH}" \
      --swift_opt=Visibility=Public \
      --swift_out="${SWIFT_OUTPUT}" \
      "${FILE_PATH}"
}


# execute `compile_protobuf_file` once for each file
find "${CURRENT_DIR}/Sources" -name '*.proto' -print0 |
while IFS= read -r -d '' proto_file; do
  compile_protobuf_file "${proto_file}"
done
