# dotenv

`dotenv` is a zsh/bash shell function that loads environment variables from a
file named `.env`. It decrypts the file using GPG if the filename is `.env.gpg`.

```console
$ cat .env
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ dotenv
dotenv: Loading .env
$ echo $AWS_ACCESS_KEY_ID
AKIAIOSFODNN7EXAMPLE
```

## Usage

Copy-paste this function definition to your `.zshrc` or `.bashrc`:

```shell
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
```

Or, clone and source [dotenv.zsh](./dotenv.zsh) with a zsh plugin manager.

## Encryption

Use gpg to encrypt your `.env`:

```console
$ gpg --symmetric .env
$ file .env.gpg
.env.gpg: GPG symmetrically encrypted data (AES cipher)
$ rm .env
```

Then, the `dotenv` function loads the encrypted file:

```console
$ dotenv
dotenv: Loading .env.gpg
Enter passphrase

Passphrase:
$ echo $AWS_ACCESS_KEY_ID
AKIAIOSFODNN7EXAMPLE
```

Note: `gpg-agent` may be running background and caching passphrase, so you may
not see the passphrase prompt.
