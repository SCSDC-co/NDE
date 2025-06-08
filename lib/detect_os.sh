#!/bin/bash

detect_os() {
    echo "Detecting your OS..."

    if [ -f /etc/os-release ]; then
        source /etc/os-release

        if [[ -n "$ID" ]]; then
            echo "Detected OS: $ID"
            echo "$ID"
        elif [[ -n "$ID_LIKE" ]]; then
            local fallback="${ID_LIKE%% *}"
            echo "ID not found, falling back to family: $fallback"
            echo "$fallback"
        else
            echo "No ID or ID_LIKE found, can't detect OS."
            echo "unknown"
        fi
    else
        echo "/etc/os-release not found."
        echo "unknown"
    fi
}
