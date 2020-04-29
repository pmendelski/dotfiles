#!/usr/bin/env bash

# Usage:
#   _travis_client [--pro] [--branch BRANCH] [--env NAME VALUE] GITHUBID GITHUBPROJECT [MESSAGE]
# For example:
#   _travis_client coditory gradle-manifest-plugin "Trigger for testing"
#
# Make sure variable $TRAVIS_ACCESS_TOKEN setup
_travis_client() {
  if [ -z "$TRAVIS_ACCESS_TOKEN" ]; then
    echo "Missing required env: TRAVIS_ACCESS_TOKEN" >&2
    return 1
  fi

  local TRAVIS_URL="travis-ci.org"
  local ENV_VARS=""
  local BRANCH="master"

  while (($#)); do
    case $1 in
      --pro|-p)
        TRAVIS_URL=travis-ci.com
        ;;
      --branch|-b)
        TRAVIS_BRANCH=$2
        shift
        ;;
      --env|-e)
        if [ -n "$ENV_VARS" ]; then
          ENV_VARS="$ENV_VARS, "
        fi
        ENV_VARS="${ENV_VARS} \"$2=$3\""
        shift
        shift
        ;;
      -?*) # Unidentified option.
        echo "Unknown option: $1" >&2
        return 1;
        ;;
      *)
        break
        ;;
    esac
    shift
  done

  if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Wrong number of arguments. Usage example:"
    echo "  travis.sh [--pro] [--branch BRANCH] [--env NAME VALUE] GITHUBID GITHUBPROJECT [MESSAGE]" >&2
    return 1
  fi

  local USER=$1
  local REPOSITORY=$2
  local MESSAGE=$3

  echo "Triggering travis"
  echo "  Travis: $TRAVIS_URL"
  echo "  User: $USER"
  echo "  Repository: $REPOSITORY"
  echo "  Branch: $BRANCH"
  echo "  Message: $MESSAGE"
  echo "  Environment: \n$ENV_VARS"

  if [ -n "$ENV_VARS" ]; then
    ENV_VARS="\"env\": [$ENV_VARS]"
  fi

  if [ -n "$MESSAGE" ]; then
    MESSAGE=",\"message\": \"$MESSAGE\""
  fi

  local BODY="{
    \"request\": {
      \"branch\":\"$BRANCH\"
      $MESSAGE
      ,\"config\": {
        $ENV_VARS
      }
    }
  }"

  echo -e "\nRequest:"
  echo "POST https://api.${TRAVIS_URL}/repo/${USER}%2F${REPOSITORY}/requests"
  echo "$BODY" | jq .

  echo -e "\nResponse:"
  # "%2F" creates a literal "/" in the URL, that is not interpreted as a
  # segment or directory separator.
  curl -s -X POST \
    -H "Content-Type: application/json; charset=UTF-8" \
    -H "Accept: application/json" \
    -H "Travis-API-Version: 3" \
    -H "Authorization: token $TRAVIS_ACCESS_TOKEN" \
    --data-binary "{ \"request\": { \"branch\": \"master\" $MESSAGE , \"config\": { $ENV_VARS } } }" \
    https://api.${TRAVIS_URL}/repo/${USER}%2F${REPOSITORY}/requests \
    | tee /tmp/travis-output.$$.txt

  # Wait for tee to print the response and add some spaceing
  sleep 1
  echo -e "\n"

  if grep -q '"@type": "error"' /tmp/travis-output.$$.txt; then
      return 1
  fi
  if grep -q 'access denied' /tmp/travis-output.$$.txt; then
      return 1
  fi

  echo "See: https://${TRAVIS_URL}/github/${USER}/${REPOSITORY}"
}

_travis_release() {
  local -r account="${1:?Expected github account}"
  local -r project="${2:?Expected github project}"
  local -r version="${3:-PATCH}"
  _travis_client --env RELEASE "$version" $account $project "Releasing version: $version"
}

travis() {
  if [ -z "$TRAVIS_ACCESS_TOKEN" ]; then
    echo "Missing required env: TRAVIS_ACCESS_TOKEN" >&2
    echo "Go to: https://travis-ci.org/account/preferences" >&2
    return 1
  fi

  case $1 in
    release)
      shift
      _travis_release "$@"
      ;;
    --help|-h)
      echo "Execute travis action:"
      echo "  Example: travis release coditory/gradle-manifest-plugin PATCH"
      return
      ;;
    *)
      break
      ;;
  esac
}
