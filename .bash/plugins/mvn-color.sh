#!/bin/bash

# Colorized mvn replacement
if hash mvn 2>/dev/null; then

    # Wrapper function for mvn command.
    mvnc() {
        local -r ESC=$(printf '\033')
        local -r COLOR_RESET="${ESC}[0m"
        local -r COLOR_RED_BOLD="${ESC}[1;31m"
        local -r COLOR_GREEN_BOLD="${ESC}[1;32m"
        local -r COLOR_YELLOW_BOLD="${ESC}[1;33m"
        local -r COLOR_BLUE_BOLD="${ESC}[1;34m"

        local -r INFO_STYLE="${COLOR_BLUE_BOLD}"
        local -r WARN_STYLE="${COLOR_YELLOW_BOLD}"
        local -r ERR_STYLE="${COLOR_RED_BOLD}"
        local -r SUCCESS_STYLE="${COLOR_GREEN_BOLD}"
        local -r FAILURE_STYLE="${COLOR_RED_BOLD}"

        # Filter mvn output using sed
        unset LANG
        LC_CTYPE=C mvn "$@" | sed \
            -e "s/\(^\[WARNING\]\)\(.*\)/${WARN_STYLE}\1${COLOR_RESET}\2/g" \
            -e "s/\(^\[ERROR\]\)\(.*\)/${ERR_STYLE}\1${COLOR_RESET}\2/g" \
            -e "s/\(^\[FATAL\]\)\(.*\)/${ERR_STYLE}\1${COLOR_RESET}\2/g" \
            -e "s/\(\-\{3,\}\)/${INFO_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(T E S T S\)/${INFO_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(^\[INFO\]\ Building .*\)/${INFO_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(^\[INFO\]\ \)\(BUILD \(SUCCESS\|SUCCESSFUL\)\)/${INFO_STYLE}\1${SUCCESS_STYLE}\2${COLOR_RESET}/g" \
            -e "s/\(^\[INFO\]\ \)\(BUILD FAILURE\)/${INFO_STYLE}\1${FAILURE_STYLE}\2${COLOR_RESET}/g" \
            -e "s/\(^\[INFO\]\)/${INFO_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(FAILURE\)/${FAILURE_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(SUCCESS\)/${SUCCESS_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(SKIPPED\)/${WARN_STYLE}\1${COLOR_RESET}/g" \
            -e "s/\(<<< FAILURE!\)/${ERR_STYLE}\1${COLOR_RESET}/g" \
            -e "s/^Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${SUCCESS_STYLE}Tests run: \1${COLOR_RESET}, Failures: ${ERR_STYLE}\2${COLOR_RESET}, Errors: ${ERR_STYLE}\3${COLOR_RESET}, Skipped: ${WARN_STYLE}\4${COLOR_RESET}/g"
        local EXIT_STATUS=${PIPESTATUS[0]}
        # Make sure formatting is reset
        echo -ne ${COLOR_RESET}
        return $EXIT_STATUS;
    }

    alias mvn="mvnc"
fi
