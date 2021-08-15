#!/bin/sh
# ---------------------------------------------------------------------------
# git-move-annotated-tag.sh - Move annotated tag without retagging

# Author: Teerapap Changwichukarn <teerapap.c@gmail.com>

# Usage: git-move-annotated-tag.sh -h for more information
#
# Manual commands:
# > git cat-file -p ${tag_name} | sed "1 s/^object .*$/object ${full_target_hash}/g" | git hash-object -w --stdin -t tag
# > git update-ref refs/tags/${tag_name} ${hash_output_from_cmd_above}
#
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}
VERSION="0.1"

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

graceful_exit() {
  clean_up
  exit
}

signal_exit() { # Handle trapped signals
  case $1 in
    INT)
      stty echo
      error_exit "Program interrupted by user" ;;
    TERM)
      echo -e "\n$PROGNAME: Program terminated" >&2
      graceful_exit ;;
    *)
      error_exit "$PROGNAME: Terminating on unknown signal" ;;
  esac
}

usage() {
  echo -e "Usage: $PROGNAME [-h|--help] [-d|--dest-repo dest_repo_dir] tag new_hash"
  echo
}

help_message() {
  echo "
Move git annotated tag to new commit hash without retagging

$(usage)

Options:
-h, --help  Display this help message and exit.
-d, --dest-repo  The repo directory of the new_hash. (Default: same as current repo)

  "
  return
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT

tag_name=
new_hash=
src_repo=`pwd`
dest_repo=`pwd`

# Parse command-line
while [[ -n $1 ]]; do
  case $1 in
    -h | --help)
      help_message; graceful_exit ;;
    -d | --dest-repo)
      shift; dest_repo="$1" ;;
    -* | --*)
      usage
      error_exit "Unknown option $1" ;;
    *)
      if [[ -z "${tag_name}" ]]; then
        tag_name=$1
      elif [[ -z "${new_hash}" ]]; then
        new_hash=$1
      fi
  esac
  shift
done

run_in_src_repo() {
  pushd $src_repo 2>&1 >/dev/null
  ${1+"$@"}
  r=$?
  popd 2>&1 >/dev/null
  return $r
}

run_in_dest_repo() {
  pushd $dest_repo 2>&1 >/dev/null
  ${1+"$@"}
  r=$?
  popd 2>&1 >/dev/null
  return $r
}

is_tag() {
  git tag | egrep "^$1$" && [[ "`git rev-parse $1`" != "`git rev-parse $1^{commit}`" ]]
}

is_valid_hash() {
  git rev-parse $1
}

validate_args() {
  [[ -z "${dest_repo}" || ! -d "${dest_repo}" ]] && usage && error_exit "Dest repo is not a git repo"
  [[ -z "${tag_name}" ]] && usage && error_exit "Please specify tag name"
  (! run_in_src_repo is_tag "${tag_name}" >/dev/null 2>&1) && usage && error_exit "${tag_name} is not an annotated tag name in ${src_repo}"
  [[ -z "${new_hash}" ]] && usage && error_exit "Please specify new hash"
  (! run_in_dest_repo is_valid_hash ${new_hash} >/dev/null 2>&1) && usage && error_exit "${new_hash} is not a valid commit or ambiguous in ${dest_repo}"
}


new_git_object() {
  git cat-file -p $1 | sed "1 s/^object .*$/object $2/g"
}

move_tag() {
  # Get full hash of target hash
  full_new_hash=`run_in_dest_repo git rev-parse "${new_hash}^{commit}"`

  echo "Move tag ${tag_name} to commit ${full_new_hash}"
  full_new_tag_hash=`run_in_src_repo new_git_object ${tag_name} ${full_new_hash} | run_in_dest_repo git hash-object -w --stdin -t tag`
  if [ $? -ne 0 ]; then
    echo "Error when move ${tag_name} to commit ${$full_new_hash}"
    return $?
  fi

  echo "Update ${tag_name} reference to ${full_new_tag_hash}"
  run_in_dest_repo git update-ref refs/tags/${tag_name} ${full_new_tag_hash}
  if [ $? -ne 0 ]; then
    echo "Error when update-ref ${tag_name} to ${full_new_tag_hash} object"
    return $?
  fi
}

# Main logic

validate_args
move_tag

graceful_exit

