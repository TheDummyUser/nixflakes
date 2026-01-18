#!/usr/bin/env bash
set -euo pipefail

find_project_root() {
    local curr_dir="$PWD"
    while [[ "$curr_dir" != "/" ]]; do
        if [[ -f "$curr_dir/pom.xml" ]] || \
           [[ -f "$curr_dir/build.gradle" ]] || \
           [[ -f "$curr_dir/build.gradle.kts" ]]; then
            echo "$curr_dir"
            return 0
        fi
        curr_dir=$(dirname "$curr_dir")
    done
    return 1
}

cleanup() {
    echo
    echo "Stopping jrun (PID $$)..."
    kill -- -$$ 2>/dev/null || true
}

trap cleanup INT TERM EXIT

PROJECT_ROOT=$(find_project_root || true)

if [[ -z "${PROJECT_ROOT:-}" ]]; then
    echo "Error: No Maven or Gradle project found."
    exit 1
fi

cd "$PROJECT_ROOT"
echo "Project Root found: $PROJECT_ROOT"

if [[ -f "pom.xml" ]]; then
    echo "Detected Maven project."
    exec ${EXECUTABLE:=./mvnw} spring-boot:run -Dspring-boot.run.arguments="$*"

elif [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
    echo "Detected Gradle project."
    exec ${EXECUTABLE:=./gradlew} bootRun --args="$*"
fi
