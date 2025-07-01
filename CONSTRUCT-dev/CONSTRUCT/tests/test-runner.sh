#!/bin/bash
# Basic test runner for CONSTRUCT development tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test configuration
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONSTRUCT_ROOT="$(cd "$TEST_DIR/../.." && pwd)"

echo -e "${BLUE}🧪 CONSTRUCT Test Runner${NC}"
echo ""

# Test categories
run_tests() {
    local category="${1:-all}"
    local tests_run=0
    local tests_passed=0
    
    case "$category" in
        "all")
            echo -e "${YELLOW}Running all available tests...${NC}"
            ;;
        "unit")
            echo -e "${YELLOW}Running unit tests...${NC}"
            ;;
        "integration")
            echo -e "${YELLOW}Running integration tests...${NC}"
            ;;
        *)
            echo -e "${RED}Unknown test category: $category${NC}"
            echo "Available categories: all, unit, integration"
            exit 1
            ;;
    esac
    
    # Check if test files exist
    if [ ! -d "$TEST_DIR/lib" ] && [ ! -d "$TEST_DIR/scripts" ] && [ ! -d "$TEST_DIR/integration" ]; then
        echo -e "${YELLOW}⚠️ No test files found${NC}"
        echo ""
        echo "Test infrastructure is ready but no test files have been created yet."
        echo ""
        echo "To add tests:"
        echo "  1. Create test files in tests/lib/, tests/scripts/, or tests/integration/"
        echo "  2. Follow the pattern in tests/README.md"
        echo "  3. Run this script again"
        echo ""
        echo -e "${GREEN}✅ Test infrastructure is properly set up${NC}"
        return 0
    fi
    
    # Run tests in each category
    for test_dir in lib scripts integration; do
        if [ "$category" = "all" ] || [ "$category" = "$test_dir" ] || [ "$category" = "unit" ] && [ "$test_dir" = "lib" ]; then
            if [ -d "$TEST_DIR/$test_dir" ]; then
                echo -e "${BLUE}Testing $test_dir...${NC}"
                
                for test_file in "$TEST_DIR/$test_dir"/test-*.sh; do
                    if [ -f "$test_file" ]; then
                        local test_name=$(basename "$test_file")
                        echo -e "  Running $test_name..."
                        
                        tests_run=$((tests_run + 1))
                        
                        if "$test_file"; then
                            tests_passed=$((tests_passed + 1))
                            echo -e "  ${GREEN}✅ $test_name passed${NC}"
                        else
                            echo -e "  ${RED}❌ $test_name failed${NC}"
                        fi
                    fi
                done
            fi
        fi
    done
    
    # Summary
    echo ""
    echo -e "${BLUE}Test Summary${NC}"
    echo "============"
    
    if [ $tests_run -eq 0 ]; then
        echo -e "${YELLOW}No tests executed${NC}"
        echo "Test infrastructure ready - add test files to begin testing"
    else
        echo "Tests run: $tests_run"
        echo "Tests passed: $tests_passed"
        
        if [ $tests_passed -eq $tests_run ]; then
            echo -e "${GREEN}✅ All tests passed!${NC}"
        else
            local failed=$((tests_run - tests_passed))
            echo -e "${RED}❌ $failed test(s) failed${NC}"
            exit 1
        fi
    fi
}

# Show help
show_help() {
    echo "CONSTRUCT Test Runner"
    echo ""
    echo "Usage: $0 [category]"
    echo ""
    echo "Categories:"
    echo "  all          Run all tests (default)"
    echo "  unit         Run unit tests (lib/ functions)"
    echo "  integration  Run integration tests"
    echo ""
    echo "Examples:"
    echo "  $0           # Run all tests"
    echo "  $0 unit      # Run only unit tests"
    echo "  $0 integration  # Run only integration tests"
}

# Main execution
main() {
    case "${1:-}" in
        --help|-h)
            show_help
            exit 0
            ;;
        "")
            run_tests "all"
            ;;
        *)
            run_tests "$1"
            ;;
    esac
}

main "$@"