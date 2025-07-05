#!/bin/bash

# Simple Interest Calculator
# Formula: Simple Interest = (Principal × Rate × Time) / 100
# Author: [FaisalSWE]
# License: Apache 2.0

set -e  # Exit on any error

# Color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage information
show_usage() {
    echo -e "${BLUE}Simple Interest Calculator${NC}"
    echo -e "${YELLOW}Usage:${NC}"
    echo "  $0 [OPTIONS]"
    echo "  $0 -p PRINCIPAL -r RATE -t TIME"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  -p, --principal AMOUNT    Principal amount (required)"
    echo "  -r, --rate PERCENTAGE     Annual interest rate (required)"
    echo "  -t, --time YEARS          Time period in years (required)"
    echo "  -i, --interactive         Interactive mode"
    echo "  -h, --help                Show this help message"
    echo "  -v, --version             Show version information"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  $0 -p 1000 -r 5 -t 3"
    echo "  $0 --principal 1500 --rate 4.5 --time 2"
    echo "  $0 -i"
    echo ""
}

# Function to display version information
show_version() {
    echo -e "${BLUE}Simple Interest Calculator v1.0.0${NC}"
    echo "Licensed under Apache 2.0"
}

# Function to validate if input is a positive number
validate_positive_number() {
    local input="$1"
    local field_name="$2"
    
    # Check if input is empty
    if [[ -z "$input" ]]; then
        echo -e "${RED}Error: $field_name cannot be empty${NC}" >&2
        return 1
    fi
    
    # Check if input is a valid number (including decimals)
    if ! [[ "$input" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "${RED}Error: $field_name must be a positive number${NC}" >&2
        return 1
    fi
    
    # Check if input is positive
    if (( $(echo "$input <= 0" | bc -l) )); then
        echo -e "${RED}Error: $field_name must be greater than 0${NC}" >&2
        return 1
    fi
    
    return 0
}

# Function to calculate simple interest
calculate_simple_interest() {
    local principal="$1"
    local rate="$2"
    local time="$3"
    
    # Calculate simple interest: (P × R × T) / 100
    local interest=$(echo "scale=2; ($principal * $rate * $time) / 100" | bc -l)
    local total_amount=$(echo "scale=2; $principal + $interest" | bc -l)
    
    echo -e "${GREEN}=== CALCULATION RESULTS ===${NC}"
    echo -e "${YELLOW}Principal Amount:${NC} \$$(printf "%.2f" "$principal")"
    echo -e "${YELLOW}Interest Rate:${NC} $rate% per annum"
    echo -e "${YELLOW}Time Period:${NC} $time years"
    echo -e "${YELLOW}Simple Interest:${NC} \$$(printf "%.2f" "$interest")"
    echo -e "${YELLOW}Total Amount:${NC} \$$(printf "%.2f" "$total_amount")"
    echo ""
}

# Function for interactive mode
interactive_mode() {
    echo -e "${BLUE}=== Interactive Simple Interest Calculator ===${NC}"
    echo ""
    
    # Get principal amount
    while true; do
        echo -n -e "${YELLOW}Enter the principal amount (\$): ${NC}"
        read -r principal
        if validate_positive_number "$principal" "Principal amount"; then
            break
        fi
    done
    
    # Get interest rate
    while true; do
        echo -n -e "${YELLOW}Enter the annual interest rate (%): ${NC}"
        read -r rate
        if validate_positive_number "$rate" "Interest rate"; then
            break
        fi
    done
    
    # Get time period
    while true; do
        echo -n -e "${YELLOW}Enter the time period (years): ${NC}"
        read -r time
        if validate_positive_number "$time" "Time period"; then
            break
        fi
    done
    
    echo ""
    calculate_simple_interest "$principal" "$rate" "$time"
}

# Function to check if bc is available
check_dependencies() {
    if ! command -v bc &> /dev/null; then
        echo -e "${RED}Error: 'bc' calculator is required but not installed${NC}" >&2
        echo -e "${YELLOW}Please install bc using:${NC}"
        echo "  Ubuntu/Debian: sudo apt-get install bc"
        echo "  CentOS/RHEL: sudo yum install bc"
        echo "  macOS: brew install bc"
        exit 1
    fi
}

# Main function
main() {
    # Check dependencies
    check_dependencies
    
    # Initialize variables
    principal=""
    rate=""
    time=""
    interactive=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--principal)
                principal="$2"
                shift 2
                ;;
            -r|--rate)
                rate="$2"
                shift 2
                ;;
            -t|--time)
                time="$2"
                shift 2
                ;;
            -i|--interactive)
                interactive=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            *)
                echo -e "${RED}Error: Unknown option '$1'${NC}" >&2
                echo "Use '$0 --help' for usage information"
                exit 1
                ;;
        esac
    done
    
    # Handle interactive mode
    if [[ "$interactive" == true ]]; then
        interactive_mode
        exit 0
    fi
    
    # Check if all required arguments are provided
    if [[ -z "$principal" || -z "$rate" || -z "$time" ]]; then
        echo -e "${RED}Error: All three parameters (principal, rate, time) are required${NC}" >&2
        echo "Use '$0 --help' for usage information"
        exit 1
    fi
    
    # Validate inputs
    if ! validate_positive_number "$principal" "Principal amount"; then
        exit 1
    fi
    
    if ! validate_positive_number "$rate" "Interest rate"; then
        exit 1
    fi
    
    if ! validate_positive_number "$time" "Time period"; then
        exit 1
    fi
    
    # Calculate and display results
    calculate_simple_interest "$principal" "$rate" "$time"
}

# Run the main function with all arguments
main "$@"
