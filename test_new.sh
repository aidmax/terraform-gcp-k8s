#!/bin/bash

check_dependency() {
  local DEPENDENCY="${1}"
  command -v "${DEPENDENCY}" >/dev/null 2>&1 || err "${DEPENDENCY} is required but not installed.  Aborting."
}

err() {
  echo -e "[ERR] ${1}"
  exit 1
}

log() {
  echo -e "[LOG] ${1}"
}

test_shell_files () {
  log "Testing shell files"
  grep -Rl '^#!/bin/bash' ./* | xargs shellcheck -e SC2044,SC1091 || err "Shellcheck errors"
}

test_yaml_files () {
  log "Testing yaml files"
  find . -type f \( -name "*.yaml" -o -name "*.yml" \) -print0 | xargs -0 yamllint
}

test_ansible_files () {
  log "Testing ansible files"
  find . -type f \( -name "*.yaml" -o -name "*.yml" \) -print0 | xargs -0 ansible-lint
}

test_terraform_files () {
  log "Testing terraform files"
  find . -type f -name "*.tf" -print0 | xargs -0 terraform validate
}

main () {
  check_dependency shellcheck
  check_dependency python3
  check_dependency yamllint
  check_dependency ansible-lint
  case $1 in
    shell)
        test_shell_files
        ;;
    yaml)
        test_yaml_files
        ;;
    ansible)
        test_ansible_files
        ;;
    terraform)
        test_terraform_files
        ;;
    *)
        test_shell_files
        test_yaml_files
        test_ansible_files
        test_terraform_files
        ;;
    esac
}

main "$@"
