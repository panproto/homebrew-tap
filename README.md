# homebrew-tap

Homebrew tap for [panproto](https://github.com/panproto/panproto).

## Install

```sh
brew install panproto/tap/panproto-cli
```

This installs the `schema` binary, a schematic version control CLI based on generalized algebraic theories.

## Usage

```sh
schema init
schema add schema.json
schema commit -m "initial schema"
schema diff old.json new.json
schema merge feature
schema log
```

See the [panproto documentation](https://github.com/panproto/panproto) for the full command reference.
