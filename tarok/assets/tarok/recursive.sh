find . -type f -name '*.webp' -exec sh -c '
    name="${1%.*}"
    echo "$name"
    cwebp "$1" -jpeg_like -o "${name}.webp"
' find-sh {} \;

