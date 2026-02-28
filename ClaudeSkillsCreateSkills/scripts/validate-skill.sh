#!/usr/bin/env bash
# Validate a skill directory: SKILL.md exists, frontmatter name matches directory, description length.
# Usage: ./scripts/validate-skill.sh [path-to-skill-dir]
# Default: parent of scripts/ (i.e. this skill's root).

set -e

SKILL_DIR="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
SKILL_MD="$SKILL_DIR/SKILL.md"
PARENT_NAME=$(basename "$SKILL_DIR")
ERR=0

echo "Validating skill at: $SKILL_DIR"
echo "Parent directory name: $PARENT_NAME"
echo ""

# 1. SKILL.md exists
if [[ ! -f "$SKILL_MD" ]]; then
  echo "FAIL: SKILL.md not found at $SKILL_MD"
  ERR=1
else
  echo "OK: SKILL.md exists"
fi

# 2. Extract name and description from frontmatter
if [[ -f "$SKILL_MD" ]]; then
  NAME=""
  DESC=""
  in_front=0
  while IFS= read -r line; do
    if [[ "$line" == "---" ]]; then
      if [[ $in_front -eq 0 ]]; then
        in_front=1
      else
        break
      fi
      continue
    fi
    if [[ $in_front -eq 1 ]]; then
      if [[ "$line" =~ ^name:[[:space:]]*(.+)$ ]]; then
        NAME="${BASH_REMATCH[1]}"
        NAME="${NAME#"${NAME%%[![:space:]]*}"}"
        NAME="${NAME%"${NAME##*[![:space:]]}"}"
      fi
      if [[ "$line" =~ ^description:[[:space:]]*(.*)$ ]]; then
        DESC="${BASH_REMATCH[1]}"
        DESC="${DESC#"${DESC%%[![:space:]]*}"}"
        DESC="${DESC%"${DESC##*[![:space:]]}"}"
      fi
    fi
  done < "$SKILL_MD"

  # name: 1-64 chars, lowercase, hyphens ok
  if [[ -z "$NAME" ]]; then
    echo "FAIL: frontmatter 'name' not found"
    ERR=1
  else
    if [[ ${#NAME} -gt 64 ]]; then
      echo "FAIL: name length ${#NAME} > 64"
      ERR=1
    elif [[ "$NAME" =~ [^a-z0-9-] ]] || [[ "$NAME" == -* ]] || [[ "$NAME" == *- ]] || [[ "$NAME" == *--* ]]; then
      echo "WARN: name should be 1-64 chars, lowercase letters/numbers/hyphens only, no leading/trailing/consecutive hyphens (got: $NAME)"
    else
      echo "OK: name='$NAME' (length ${#NAME})"
    fi
  fi

  # description: 1-1024 chars
  if [[ -z "$DESC" ]]; then
    echo "FAIL: frontmatter 'description' not found or empty"
    ERR=1
  else
    LEN=${#DESC}
    if [[ $LEN -lt 1 ]]; then
      echo "FAIL: description empty"
      ERR=1
    elif [[ $LEN -gt 1024 ]]; then
      echo "FAIL: description length $LEN > 1024"
      ERR=1
    else
      echo "OK: description length $LEN (max 1024)"
    fi
  fi

  # name vs directory name (warning only; directory might be PascalCase for repo display)
  if [[ -n "$NAME" ]] && [[ "$PARENT_NAME" != "$NAME" ]]; then
    echo "WARN: name '$NAME' does not match parent directory name '$PARENT_NAME' (spec recommends they match; use kebab-case directory for strict compliance)"
  fi
fi

echo ""
if [[ $ERR -eq 0 ]]; then
  echo "Validation passed."
  exit 0
else
  echo "Validation had failures."
  exit 1
fi
