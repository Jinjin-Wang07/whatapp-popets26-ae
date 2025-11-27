#!/bin/bash

# Environment Test Script for Artifact Evaluation
# Tests all required components for WhatsApp fingerprinting artifact

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASSED=0
FAILED=0

# Test function
test_check() {
    local name="$1"
    local cmd="$2"
    
    echo -n "Testing $name ... "
    if eval "$cmd" >/dev/null 2>&1; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
}

echo "========================================="
echo "Environment Test for Artifact Evaluation"
echo "========================================="

# 1. Test dataset directory and CSV files
echo -e "\n1. Dataset Validation"
test_check "/dataset/raw exists" "[ -d /dataset/raw ]"
if [ -d /dataset/raw ]; then
    csv_count=$(find /dataset/raw -name "*.csv" | wc -l)
    test_check "49 CSV files in /dataset/raw" "[ $csv_count -eq 49 ]"
    echo "   Found $csv_count CSV files"
fi

# 2. Test workspace directories
echo -e "\n2. Workspace Structure"
test_check "/workspaces exists" "[ -d /workspaces ]"
test_check "/workspaces/fingerprinting exists and not empty" "[ -d /workspaces/fingerprinting ] && [ $(find /workspaces/fingerprinting -maxdepth 1 | wc -l) -gt 1 ]"
test_check "/workspaces/whatapp-pdcp-defense exists and not empty" "[ -d /workspaces/whatapp-pdcp-defense ] && [ $(find /workspaces/whatapp-pdcp-defense -maxdepth 1 | wc -l) -gt 1 ]"

# 3. Test required scripts
echo -e "\n3. Required Scripts"
test_check "2_run_attack_models.sh exists and executable" "[ -x /workspaces/2_run_attack_models.sh ]"
test_check "3_run_defense_demo.sh exists and executable" "[ -x /workspaces/3_run_defense_demo.sh ]"

# 4. Test srsRAN binaries
echo -e "\n4. srsRAN Components"
test_check "srsenb binary exists and executable" "[ -x /workspaces/whatapp-pdcp-defense/build/srsenb/src/srsenb ]"
test_check "srsepc binary exists and executable" "[ -x /workspaces/whatapp-pdcp-defense/build/srsepc/src/srsepc ]"
test_check "srsue binary exists and executable" "[ -x /workspaces/whatapp-pdcp-defense/build/srsue/src/srsue ]"

# Test version for srsenb and srsue
if [ -x /workspaces/whatapp-pdcp-defense/build/srsenb/src/srsenb ]; then
    echo -n "Testing srsenb version 22.4.1 ... "
    if /workspaces/whatapp-pdcp-defense/build/srsenb/src/srsenb --version 2>&1 | grep -q "Version 22.4.1"; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
fi

if [ -x /workspaces/whatapp-pdcp-defense/build/srsue/src/srsue ]; then
    echo -n "Testing srsue version 22.4.1 ... "
    if /workspaces/whatapp-pdcp-defense/build/srsue/src/srsue --version 2>&1 | grep -q "Version 22.4.1"; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}FAIL${NC}"
        FAILED=$((FAILED + 1))
    fi
fi

# 5. Test Python environment
echo -e "\n5. Python Environment"
test_check "Python 3 available" "command -v python3"
test_check "pip available" "command -v pip"

# 6. Test Python packages
echo -e "\n6. Python Packages"
test_check "TensorFlow works" "python3 -c 'import tensorflow as tf; tf.constant([1,2,3])'"
test_check "PyTorch works" "python3 -c 'import torch; torch.tensor([1,2,3])'"
test_check "NumPy works" "python3 -c 'import numpy'"
test_check "Pandas works" "python3 -c 'import pandas'"
test_check "scikit-learn works" "python3 -c 'import sklearn'"
test_check "tqdm works" "python3 -c 'import tqdm'"

# Final results
echo -e "\n========================================="
echo "Test Results:"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED - Environment ready for artifact evaluation${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed - Please fix before proceeding${NC}"
    exit 1
fi