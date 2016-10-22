#!/bin/bash

nextTag() {
    local tagname="";
    local nexttags="$(git tag -l --contains $(git curr-commit))";
    local nextcommitresult=0;
    while [ -z "$tagname" ] && [ ! -z "$nexttags" ] && [ $nextcommitresult -eq 0 ]; do
        git next-commit $1;
        nextcommitresult=$?;
        tagname="$(git describe --exact-match --tags --abbrev=0)";
        nexttags="$(git tag -l --contains $(git curr-commit))";
    done;
}

nextTag "$@";
