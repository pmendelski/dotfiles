declare -r PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"

ln -fs "$HOME/.conky" "$PWD/conky/.conky"

# Place for packages ...will come soon
