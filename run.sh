#!/usr/bin/env bash
# Generate build files with premake5, build, and run the app.
#
# Usage:
#   ./run.sh d [args...]   Build and run Debug
#   ./run.sh r [args...]   Build and run Release

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

usage() {
    echo "Usage: $0 <d|r> [app args...]" >&2
    echo "  d  Debug build" >&2
    echo "  r  Release build" >&2
    exit 1
}

[[ $# -ge 1 ]] || usage

case "$1" in
    d) config="debug";   dir="Debug"   ;;
    r) config="release"; dir="Release" ;;
    *) usage ;;
esac
shift

if ! command -v premake5 >/dev/null 2>&1; then
    echo "error: premake5 not found in PATH" >&2
    exit 1
fi

jobs="$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)"

premake5 gmake
make -C build config="$config" -j"$jobs"

exec "./build/bin/$dir/cc" "$@"
