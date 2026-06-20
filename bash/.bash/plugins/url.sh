# Copy a query param from a source URL into one or more target URLs.
# Usage: query_param_replace <PARAM_NAME> <SRC_URL> <TARGET_URL>...
# Reads PARAM_NAME from SRC_URL, then sets/replaces it in every target URL.
# Each rewritten target URL is printed on its own line.
# Errors if SRC_URL does not contain PARAM_NAME.
function query_param_replace() {
  local param="$1" src="$2"
  local query value rest pair name found
  local target base tquery frag newquery found_t

  if [ -z "$param" ] || [ -z "$src" ] || [ "$#" -lt 3 ]; then
    echo "usage: query_param_replace <PARAM_NAME> <SRC_URL> <TARGET_URL>..." >&2
    return 2
  fi
  shift 2

  # Pull the query string out of the source URL (drop any #fragment).
  case "$src" in
    *\?*) query="${src#*\?}"; query="${query%%#*}" ;;
    *) echo "query_param_replace: source URL has no query string" >&2; return 1 ;;
  esac

  # Find PARAM_NAME's value in the source query string.
  value=""
  found=0
  rest="$query"
  while [ -n "$rest" ]; do
    pair="${rest%%&*}"
    if [ "$pair" = "$rest" ]; then rest=""; else rest="${rest#*&}"; fi
    name="${pair%%=*}"
    if [ "$name" = "$param" ]; then
      value="${pair#*=}"
      found=1
      break
    fi
  done

  if [ "$found" -eq 0 ]; then
    echo "query_param_replace: source URL has no '$param' query param" >&2
    return 1
  fi

  # Set/replace PARAM_NAME in each target URL.
  for target in "$@"; do
    case "$target" in
      *#*) frag="#${target#*#}"; target="${target%%#*}" ;;
      *) frag="" ;;
    esac
    case "$target" in
      *\?*) base="${target%%\?*}"; tquery="${target#*\?}" ;;
      *) base="$target"; tquery="" ;;
    esac

    newquery=""
    found_t=0
    rest="$tquery"
    while [ -n "$rest" ]; do
      pair="${rest%%&*}"
      if [ "$pair" = "$rest" ]; then rest=""; else rest="${rest#*&}"; fi
      [ -z "$pair" ] && continue
      name="${pair%%=*}"
      if [ "$name" = "$param" ]; then
        pair="${param}=${value}"
        found_t=1
      fi
      if [ -z "$newquery" ]; then newquery="$pair"; else newquery="${newquery}&${pair}"; fi
    done

    if [ "$found_t" -eq 0 ]; then
      if [ -z "$newquery" ]; then newquery="${param}=${value}"; else newquery="${newquery}&${param}=${value}"; fi
    fi

    printf '%s?%s%s\n' "$base" "$newquery" "$frag"
  done
}

# Convenience wrapper: copy the "token" query param from SRC_URL into targets.
# Usage: query_token_replace <SRC_URL> <TARGET_URL>...
function query_token_replace() {
  query_param_replace token "$@"
}
