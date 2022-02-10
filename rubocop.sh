#!/bin/bash

set -eu

function main() {
    diff_files=$(git diff-tree --no-commit-id --name-only --diff-filter=cdr -r $GITHUB_SHA)

    targets=()
    for v in ${diff_files[@]}; do
        f=$(basename $v)
        if [[ "${f##*.}" != "rb" ]]; then
            continue
        fi
        targets+=(${v?})
    done

    if [ "${#targets[*]}" == 0 ]; then
        echo "GITHUB_SHA: ${GITHUB_SHA}"
        echo "diff_files: ${diff_files[*]}"
        echo "targets: ${targets[*]}"
        echo ".rb file not found"
        exit 0
    fi

    echo ".rb file ${#targets[*]} found."

    bundle exec rubocop -P "${targets[@]}"
}

main