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
DATASET_DIR="/dataset/raw"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored banner
print_banner() {
    echo -e "\n${CYAN}================================================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}================================================================${NC}\n"
}

# Function to print status messages
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo -e "${BLUE}Usage:${NC} $0 [MODEL_TYPE]"
    echo ""
    echo -e "${BLUE}Available Models:${NC}"
    echo "  cnn    - Convolutional Neural Network (includes data preparation and training)"
    echo "  svm    - Support Vector Machine"
    echo "  knn    - K-Nearest Neighbors"
    echo "  mlp    - Multi-Layer Perceptron"
    echo "  all    - Run all traditional models (SVM, KNN, MLP)"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0 cnn     # Run CNN model with full pipeline"
    echo "  $0 svm     # Run SVM model only"
    echo "  $0 all     # Run all traditional models"
}

# Function to check if dataset exists
check_dataset() {
    if [ ! -d "$DATASET_DIR" ] || [ -z "$(ls -A "$DATASET_DIR" 2>/dev/null)" ]; then
        print_error "Dataset directory is empty or does not exist: $DATASET_DIR"
        print_warning "Please ensure the dataset is properly loaded before running models."
        exit 1
    fi
    print_status "Dataset found at: $DATASET_DIR"
}

# Function to run CNN model
run_cnn_model() {
    print_banner "RUNNING CNN MODEL WITH FULL PIPELINE"
    
    local cnn_dir="${SCRIPT_DIR}/fingerprinting/cnn"
    
    print_status "CNN model includes:"
    echo "  1. Data preparation (feature extraction)"
    echo "  2. Model training and testing"
    echo ""
    
    # Check if CNN dir exist
    if [ ! -d "${cnn_dir}" ]; then
        print_error "CNN folder not found: ${cnn_dir}"
        exit 1
    fi
    
    # Run data preparation
    print_status "Step 1/2: Running data preparation..."
    cd "$cnn_dir"
    bash ./data_prepare.sh
    
    # Run training and testing
    print_status "Step 2/2: Running training and testing..."
    bash ./training_and_test.sh
    
    print_status "CNN model execution completed!"
}

# Function to run traditional models
run_traditional_model() {
    local model_type=$1
    
    print_banner "RUNNING ${model_type^^} MODEL"
    
    local models_dir="${SCRIPT_DIR}/fingerprinting/compared_models"
    local run_script="${models_dir}/run_models.py"
    
    print_status "Model: $model_type"
    print_status "Dataset: $DATASET_DIR"
    echo ""
    
    # Check if script exists
    if [ ! -f "$run_script" ]; then
        print_error "Model runner script not found: $run_script"
        exit 1
    fi
    
    # Run the model
    print_status "Executing $model_type model..."
    cd "$models_dir"
    python3 "$run_script" --input "$DATASET_DIR" --model "$model_type"
    
    print_status "$model_type model execution completed!"
}

# Main execution
main() {
    # Print header
    print_banner "WHATSAPP FINGERPRINTING ATTACK MODELS"
    
    # Check arguments
    if [ $# -eq 0 ]; then
        print_error "No model specified!"
        show_usage
        exit 1
    fi
    
    local model_type=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # Validate model type
    case $model_type in
        cnn|svm|knn|mlp|all)
            ;;
        *)
            print_error "Invalid model type: $1"
            show_usage
            exit 1
            ;;
    esac
    
    # Check dataset
    check_dataset
    
    # Execute based on model type
    case $model_type in
        cnn)
            run_cnn_model
            ;;
        svm|knn|mlp)
            run_traditional_model "$model_type"
            ;;
        all)
            print_banner "RUNNING ALL TRADITIONAL MODELS (SVM, KNN, MLP)"
            for model in svm knn mlp; do
                run_traditional_model "$model"
                echo ""
            done
            print_status "All traditional models completed!"
            ;;
    esac
    
    print_banner "MODEL EXECUTION FINISHED"
}

# Run main function with all arguments
main "$@"