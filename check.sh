#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "========================================"
echo " Running Automated Tests for Assignment "
echo "========================================"

# Track overall pass/fail status
FAILED=0

# Helper function to run a test case
run_test() {
    local q_num=$1
    local src_file=$2
    local input_data=$3
    local expected_keyword_1=$4
    local expected_keyword_2=$5

    echo -e "\n--- Testing Question $q_num ($src_file) ---"

    if [ ! -f "$src_file" ]; then
        echo -e "${RED}[FAIL] File $src_file not found.${NC}"
        FAILED=1
        return
    fi

    # Compile source file
    g++ -std=c++11 "$src_file" -o "q${q_num}_executable" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}[FAIL] Compilation failed for $src_file.${NC}"
        FAILED=1
        return
    fi

    # Execute with test input and capture output
    output=$(echo "$input_data" | ./q${q_num}_executable 2>&1)

    # Clean up executable
    rm -f "q${q_num}_executable"

    # Check output against expected keywords
    if echo "$output" | grep -qi "$expected_keyword_1" && echo "$output" | grep -qi "$expected_keyword_2"; then
        echo -e "${GREEN}[PASS] Question $q_num passed the test case!${NC}"
        echo "Program Output:"
        echo "$output"
    else
        echo -e "${RED}[FAIL] Question $q_num failed the test case.${NC}"
        echo "Actual Output:"
        echo "$output"
        FAILED=1
    fi
}

# --- TEST CASE FOR QUESTION 1 ---
# Input: 3 persons -> (25, 175.5), (30, 160.0), (22, 182.0)
# Expected: Max age person (30) and Max height person (182)
Q1_INPUT="3
25 175.5
30 160.0
22 182.0"

# Locate source file for Q1 (.cpp or no extension)
Q1_FILE=""
if [ -f "q1.cpp" ]; then Q1_FILE="q1.cpp"; elif [ -f "q1" ]; then Q1_FILE="q1"; fi

run_test "1" "$Q1_FILE" "$Q1_INPUT" "30" "182"


# --- TEST CASE FOR QUESTION 2 ---
# Input: (3 + 4i) and (1 + 2i)
# Expected: Sum (4 + 6i) and Difference (2 + 2i)
Q2_INPUT="3 4
1 2"

# Locate source file for Q2 (.cpp or no extension)
Q2_FILE=""
if [ -f "q2.cpp" ]; then Q2_FILE="q2.cpp"; elif [ -f "q2" ]; then Q2_FILE="q2"; fi

run_test "2" "$Q2_FILE" "$Q2_INPUT" "4" "2"


echo -e "\n========================================"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All test cases passed successfully!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed. Please review your code.${NC}"
    exit 1
fi
