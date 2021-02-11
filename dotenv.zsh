dotenv() {
    if [ $# -eq 0 ]; then
        [ -f .env.gpg ] && set -- .env.gpg "$@"
        [ -f .env     ] && set -- .env     "$@"
    fi

    set -a
    while [ $# -gt 0 ]; do
        echo "dotenv: Loading $1"
        case "$1" in
        *.gpg)
            eval "$(gpg --quiet --decrypt --yes "$1")"
            ;;
        */*)
            . "$1"
            ;;
        *)
            . "./$1"
        esac
        shift
    done
    set +a
}
