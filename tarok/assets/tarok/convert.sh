find . -type f -name '*.png' -exec sh -c '
    name="${1%.*}"
    echo "$name"
    convert "$1" "${name}.webp"
' find-sh {} \;