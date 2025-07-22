#!/bin/bash
# Common functions for CONSTRUCT init system

# Color definitions
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export GRAY='\033[0;90m'
export NC='\033[0m'

# Logging functions
log_error() {
    echo -e "${RED}❌ $1${NC}" >&2
    [ -n "$LOG_FILE" ] && echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    [ -n "$LOG_FILE" ] && echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    [ -n "$LOG_FILE" ] && echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    [ -n "$LOG_FILE" ] && echo "[SUCCESS] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

log_debug() {
    [ -n "$DEBUG" ] && echo -e "${GRAY}🔍 $1${NC}"
    [ -n "$LOG_FILE" ] && echo "[DEBUG] $(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# Validation functions
validate_directory() {
    local dir="$1"
    local name="$2"
    
    if [ -z "$dir" ]; then
        log_error "$name directory not specified"
        return 1
    fi
    
    if [ ! -d "$dir" ]; then
        log_error "$name directory does not exist: $dir"
        return 1
    fi
    
    # Basic path traversal check
    if [[ "$dir" == *".."* ]]; then
        log_error "Invalid $name directory path: $dir"
        return 1
    fi
    
    return 0
}

check_required_tools() {
    local missing_tools=()
    
    for tool in "$@"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install missing tools before continuing"
        return 1
    fi
    
    return 0
}

# Cleanup handlers
setup_cleanup() {
    # Array to track temp files
    TEMP_FILES=()
    
    # Set up trap for cleanup
    trap cleanup_on_exit EXIT INT TERM
}

add_temp_file() {
    TEMP_FILES+=("$1")
}

cleanup_on_exit() {
    local exit_code=$?
    
    # Clean up temp files
    for file in "${TEMP_FILES[@]}"; do
        [ -f "$file" ] && rm -f "$file"
    done
    
    # Additional cleanup can be added here
    
    exit $exit_code
}

# Token bucket rate limiting
TOKEN_BUCKET_SIZE="${CONSTRUCT_TOKEN_BUCKET_SIZE:-10}"
TOKEN_REFILL_RATE="${CONSTRUCT_TOKEN_REFILL_RATE:-2}"
TOKENS_AVAILABLE="${CONSTRUCT_TOKEN_BUCKET_SIZE:-10}"
LAST_REFILL_TIME=$(date +%s)

# Consume an API token using token bucket algorithm
consume_api_token() {
    local current_time=$(date +%s)
    local elapsed=$((current_time - LAST_REFILL_TIME))
    
    # Refill tokens based on elapsed time
    local tokens_to_add=$((elapsed * TOKEN_REFILL_RATE))
    TOKENS_AVAILABLE=$((TOKENS_AVAILABLE + tokens_to_add))
    
    # Cap at bucket size
    if [ $TOKENS_AVAILABLE -gt $TOKEN_BUCKET_SIZE ]; then
        TOKENS_AVAILABLE=$TOKEN_BUCKET_SIZE
    fi
    
    LAST_REFILL_TIME=$current_time
    
    # Wait if no tokens available
    local wait_count=0
    while [ $TOKENS_AVAILABLE -lt 1 ]; do
        if [ $wait_count -eq 0 ]; then
            log_debug "Rate limit: waiting for tokens (available: $TOKENS_AVAILABLE)"
        fi
        sleep 0.5
        wait_count=$((wait_count + 1))
        
        # Recalculate tokens after wait
        current_time=$(date +%s)
        elapsed=$((current_time - LAST_REFILL_TIME))
        tokens_to_add=$((elapsed * TOKEN_REFILL_RATE))
        TOKENS_AVAILABLE=$((TOKENS_AVAILABLE + tokens_to_add))
        if [ $TOKENS_AVAILABLE -gt $TOKEN_BUCKET_SIZE ]; then
            TOKENS_AVAILABLE=$TOKEN_BUCKET_SIZE
        fi
        LAST_REFILL_TIME=$current_time
    done
    
    # Consume a token
    TOKENS_AVAILABLE=$((TOKENS_AVAILABLE - 1))
    log_debug "Consumed API token (remaining: $TOKENS_AVAILABLE)"
}

# Claude SDK helpers with retry logic
call_claude_with_retry() {
    local max_retries=3
    local retry_delay=5
    local timeout="${1:-30}"
    local prompt_file="$2"
    local output_file="$3"
    local format="${4:-text}"
    
    local attempt=1
    local success=false
    
    while [ $attempt -le $max_retries ] && [ "$success" = "false" ]; do
        # Use token bucket rate limiting
        consume_api_token
        
        log_debug "Claude API call attempt $attempt/$max_retries"
        
        if [ "$format" = "json" ]; then
            if timeout "$timeout" claude --output-format json < "$prompt_file" > "$output_file" 2>"${output_file}.err"; then
                # Check if response is valid
                if command -v jq >/dev/null 2>&1 && jq -e '.is_error == false' "$output_file" >/dev/null 2>&1; then
                    success=true
                    rm -f "${output_file}.err"
                else
                    log_warning "Claude returned error response (attempt $attempt)"
                    [ -f "${output_file}.err" ] && log_debug "Error: $(cat "${output_file}.err")"
                fi
            else
                log_warning "Claude API timeout or failure (attempt $attempt)"
                [ -f "${output_file}.err" ] && log_debug "Error: $(cat "${output_file}.err")"
            fi
        else
            if timeout "$timeout" claude < "$prompt_file" > "$output_file" 2>"${output_file}.err"; then
                success=true
                rm -f "${output_file}.err"
            else
                log_warning "Claude API timeout or failure (attempt $attempt)"
                [ -f "${output_file}.err" ] && log_debug "Error: $(cat "${output_file}.err")"
            fi
        fi
        
        if [ "$success" = "false" ] && [ $attempt -lt $max_retries ]; then
            log_info "Retrying in $retry_delay seconds..."
            sleep $retry_delay
            retry_delay=$((retry_delay * 2))  # Exponential backoff
        fi
        
        attempt=$((attempt + 1))
    done
    
    if [ "$success" = "false" ]; then
        log_error "Claude API call failed after $max_retries attempts"
        return 1
    fi
    
    return 0
}

# Progress tracking
show_progress() {
    local current="$1"
    local total="$2"
    local task="$3"
    
    local percent=$((current * 100 / total))
    echo -e "${GRAY}Progress: [$current/$total] $percent% - $task${NC}"
}

# Cache management
CACHE_DIR="${CONSTRUCT_CACHE_DIR:-$HOME/.cache/construct}"
CACHE_MAX_AGE="${CONSTRUCT_CACHE_MAX_AGE:-3600}"  # 1 hour default

# Initialize cache directory
init_cache() {
    mkdir -p "$CACHE_DIR"
    # Clean old cache files (older than 7 days)
    if command -v find >/dev/null 2>&1; then
        find "$CACHE_DIR" -type f -name "*.json" -mtime +7 -delete 2>/dev/null || true
    fi
}

# Generate cache key from content
get_cache_key() {
    local content="$1"
    local category="${2:-general}"
    local version="${3:-1.0}"
    
    # Use sha256sum or shasum depending on availability
    if command -v sha256sum >/dev/null 2>&1; then
        echo -n "${content}|${category}|${version}" | sha256sum | cut -d' ' -f1
    elif command -v shasum >/dev/null 2>&1; then
        echo -n "${content}|${category}|${version}" | shasum -a 256 | cut -d' ' -f1
    else
        # Fallback to simple hash
        echo -n "${content}|${category}|${version}" | cksum | cut -d' ' -f1
    fi
}

# Check cache for existing result
check_cache() {
    local cache_key="$1"
    local max_age="${2:-$CACHE_MAX_AGE}"
    local cache_file="$CACHE_DIR/${cache_key}.json"
    
    if [ -f "$cache_file" ]; then
        # Get file age in seconds
        local current_time=$(date +%s)
        local file_time
        if [[ "$OSTYPE" == "darwin"* ]]; then
            file_time=$(stat -f %m "$cache_file" 2>/dev/null || echo 0)
        else
            file_time=$(stat -c %Y "$cache_file" 2>/dev/null || echo 0)
        fi
        
        local file_age=$((current_time - file_time))
        
        if [ $file_age -lt $max_age ]; then
            log_debug "Cache hit for key ${cache_key:0:8}... (age: ${file_age}s)"
            cat "$cache_file"
            return 0
        else
            log_debug "Cache expired for key ${cache_key:0:8}... (age: ${file_age}s)"
        fi
    else
        log_debug "Cache miss for key ${cache_key:0:8}..."
    fi
    
    return 1
}

# Save result to cache
save_cache() {
    local cache_key="$1"
    local content="$2"
    local cache_file="$CACHE_DIR/${cache_key}.json"
    
    echo "$content" > "$cache_file"
    log_debug "Saved to cache: ${cache_key:0:8}..."
}

# Claude SDK with caching
call_claude_with_cache() {
    local timeout="${1:-30}"
    local prompt_file="$2"
    local output_file="$3"
    local format="${4:-text}"
    local cache_category="${5:-general}"
    
    # Generate cache key from prompt
    local prompt_content=$(cat "$prompt_file")
    local cache_key=$(get_cache_key "$prompt_content" "$cache_category" "$format")
    
    # Check cache first
    if check_cache "$cache_key" > "$output_file"; then
        return 0
    fi
    
    # Call API if not cached
    if call_claude_with_retry "$timeout" "$prompt_file" "$output_file" "$format"; then
        # Cache successful result
        save_cache "$cache_key" "$(cat "$output_file")"
        return 0
    fi
    
    return 1
}

# Initialize cache on module load
init_cache

# Export functions
export -f log_error log_warning log_info log_success log_debug
export -f validate_directory check_required_tools
export -f setup_cleanup add_temp_file cleanup_on_exit
export -f consume_api_token call_claude_with_retry call_claude_with_cache
export -f show_progress init_cache get_cache_key check_cache save_cache