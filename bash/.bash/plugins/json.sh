function json-prettify() {
  local -r json="$([ ! -t 0 ] && cat || echo "$1")"
  node -e "console.log(JSON.stringify(JSON.parse(process.argv[1]), null, 2))" "$json"
}

function json-sort() {
  local -r json="$([ ! -t 0 ] && cat || echo "$1")"
  node -e "
  function sort(x) {
    return Array.isArray(x)
      ? x.map(i => sort(i)).sort()
      : (x !== null && typeof x == 'object'
        ? Object.fromEntries(Object.entries(x).map(([k, v]) => [k, sort(v)]).sort(([a], [b]) => a.localeCompare(b)))
        : x)
  }
  console.log(JSON.stringify(sort(JSON.parse(process.argv[1])), null, 2))" "$json"
}
