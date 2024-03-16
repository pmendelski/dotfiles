#!/usr/bin/env bash

if [[ $- == *i* ]]; then
  alias k='kubectl "--context=${KUBECTL_CONTEXT:-$(kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}'
else
  k() {
    kubectl "--context=${KUBECTL_CONTEXT:-$(kubectl config current-context)}" ${KUBECTL_NAMESPACE/[[:alnum:]-]*/--namespace=${KUBECTL_NAMESPACE}}
  }
fi

kc() {
  local contexts="$(kubectl config get-contexts --output='name')"
  if [ ! $? -eq 0 ]; then
    echo "Could not read kubectl contexts" >&2
    return 1
  fi
  if [ $# -eq 0 ]; then
    echo -n "$contexts"
    echo -e "\n\nActive contexts:" >&2
    echo "kubectl: $(kubectl config current-context)" >&2
    echo "      k: $KUBECTL_CONTEXT" >&2
    return 0
  fi
  local context="$1"
  if [ -z "$context" ]; then
    unset KUBECTL_CONTEXT
    unset KUBECTL_NAMESPACE
    echo "Unset kubectl context" >&2
    return 0
  fi
  if [ -z "$contexts" ]; then
    echo "No contexts available" >&2
    return 1
  fi
  if ! echo "$contexts" | grep -q "$context"; then
    echo -n "Context '$context' not found. Available contexts:\n$contexts" >&2
    return 1
  fi
  export KUBECTL_CONTEXT="$context"
  echo "Context switched: '$context'" >&2
  local namespace="$2"
  if [ -n "$namespace" ]; then
    kn "$2"
  else
    unset KUBECTL_NAMESPACE
  fi
}

kn() {
  local namespaces="$(kubectl get namespaces -o=jsonpath='{range .items[*].metadata.name}{@}{"\n"}{end}')"
  if [ ! $? -eq 0 ]; then
    echo "Could not read kubectl namespaces" >&2
    return 1
  fi
  if [ $# -eq 0 ]; then
    echo -n "$namespaces"
    echo -e "\n\nActive namepsaces:" >&2
    echo "kubectl: $(kubectl config view --minify -o jsonpath='{..namespace}')" >&2
    echo "      k: $KUBECTL_NAMESPACE" >&2
    return 0
  fi
  local namespace="$1"
  if [ -z "$namespaces" ]; then
    echo "No namespaces available" >&2
    return 1
  fi
  if [ -z "$namespace" ]; then
    unset KUBECTL_NAMESPACE
    echo "Unset kubectl namespace" >&2
    return 0
  fi
  if ! echo "$namespaces" | grep -q "$namespace"; then
    echo -n "Namespace '$namespace' not found. Available namespaces:\n$namespaces" >&2
    return 1
  fi
  export KUBECTL_NAMESPACE="$namespace"
  echo "Context namespace: '$namespace'" >&2
}

if [ -n "${ZSH_VERSION-}" ]; then
  _kc() {
    compadd -J args -o nosort -- $(kc 2>/dev/null)
  }
  compdef _kc kc
  _kn() {
    compadd -J args -o nosort -- $(kn 2>/dev/null)
  }
  compdef _kn kn
elif [ -n "$BASH_VERSION" ]; then
  _kc() {
    local curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(kc 2>/dev/null)" -- $curr_arg))
  }
  complete -F _kc kc
  _kn() {
    local curr_arg=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(kn 2/dev/null)" -- $curr_arg))
  }
  complete -F _kn kn
fi
