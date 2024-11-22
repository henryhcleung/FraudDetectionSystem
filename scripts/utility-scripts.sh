#!/bin/bash
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Java version
check_java_version() {
    if command_exists java; then
        java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo "Java version: $java_version"
    else
        echo "Java is not installed"
        exit 1
    fi
}

# Function to check Maven version
check_maven_version() {
    if command_exists mvn; then
        mvn_version=$(mvn --version | awk 'NR==1{print $3}')
        echo "Maven version: $mvn_version"
    else
        echo "Maven is not installed"
        exit 1
    fi
}

# Function to check Docker version
check_docker_version() {
    if command_exists docker; then
        docker_version=$(docker version --format '{{.Server.Version}}')
        echo "Docker version: $docker_version"
    else
        echo "Docker is not installed"
        exit 1
    fi
}

# Main function to run all checks
run_checks() {
    check_java_version
    check_maven_version
    check_docker_version
}

# Run the checks
run_checks