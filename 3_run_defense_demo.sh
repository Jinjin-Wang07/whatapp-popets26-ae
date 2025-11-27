#!/bin/bash

# ===================================================================
# WhatsApp Fingerprinting Attack Models Runner
# ===================================================================
# This script allows users to run different machine learning models
# for traffic fingerprinting analysis.
# ===================================================================

set -e

# Get the absolute path of the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd ${SCRIPT_DIR}/whatapp-pdcp-defense/confg_defense && ${SCRIPT_DIR}/whatapp-pdcp-defense/confg_defense/tmux_launch.sh