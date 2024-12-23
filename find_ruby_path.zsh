#!/bin/zsh

function setup_env_vars {
  # Initialize an associative array for environment variables
  local -A env_vars

  local ruby_path_bin="$HOMEBREW_PREFIX/opt/ruby/bin"
  local gem_bin="$ruby_path_bin/gem"

  if [[ -d "$ruby_path_bin" && -x "$gem_bin" ]]; then
    gem_dir=$(${gem_bin} environment gemdir)
    env_vars[PATH]="$gem_dir:$ruby_path_bin:$PATH"
  fi 

  # Print the dictionary to confirm its contents
  echo "{"
  for key value in "${(@kv)env_vars}"; do
    echo "    \"$key\":\"$value\""
  done
  echo "}"
}

setup_env_vars
