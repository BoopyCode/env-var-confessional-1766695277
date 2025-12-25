#!/usr/bin/env bash
# ENV Var Confessional - Where your environment variables come to confess their sins
# Usage: ./env_confessional.sh <env_file> <required_vars>

# The priest is in. Let the confessions begin.
if [ $# -lt 2 ]; then
    echo "Usage: $0 <env_file> <required_var1> [required_var2 ...]"
    echo "Example: $0 .env DATABASE_URL API_KEY SECRET_TOKEN"
    exit 1
fi

ENV_FILE="$1"
shift
REQUIRED_VARS=("$@")

# Check if the sacred text (env file) even exists
if [ ! -f "$ENV_FILE" ]; then
    echo "🚨 CONFESSION FAILED: '$ENV_FILE' doesn't exist. Did you check the holy scriptures?"
    exit 1
fi

# Load the environment variables with the reverence they deserve
set -a
source "$ENV_FILE" 2>/dev/null
set +a

MISSING_VARS=()
EMPTY_VARS=()

# The inquisition begins
for var in "${REQUIRED_VARS[@]}"; do
    if [[ -z "${!var+x}" ]]; then
        # Variable doesn't exist - a mortal sin
        MISSING_VARS+=("$var")
    elif [[ -z "${!var}" ]]; then
        # Variable exists but is empty - a venial sin
        EMPTY_VARS+=("$var")
    fi
done

# Deliver the verdict
if [ ${#MISSING_VARS[@]} -eq 0 ] && [ ${#EMPTY_VARS[@]} -eq 0 ]; then
    echo "✅ ABSOLUTION GRANTED: All required environment variables are present and accounted for!"
    echo "   Go forth and code without fear, my child."
    exit 0
else
    echo "📜 CONFESSION REPORT:"
    
    if [ ${#MISSING_VARS[@]} -gt 0 ]; then
        echo "   ❌ MISSING (Go to environment jail):"
        for var in "${MISSING_VARS[@]}"; do
            echo "     - $var (completely absent, like your motivation on Monday)"
        done
    fi
    
    if [ ${#EMPTY_VARS[@]} -gt 0 ]; then
        echo "   ⚠️  EMPTY (Suspended sentence):"
        for var in "${EMPTY_VARS[@]}"; do
            echo "     - $var (exists but is empty, like your coffee cup after debugging)"
        done
    fi
    
    echo "\n🛐 PENANCE: Fix these variables in '$ENV_FILE' and run this confessional again."
    exit 1
fi