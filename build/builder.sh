#!/bin/bash

set -o errexit  # Exit if error
set -o nounset  # Exit if variable not initalized
set +h          # Disable hashall

shopt -s -o pipefail


# Clear directory stack
dirs -c

_run_directory=$(cd $(dirname $0); pwd)
_src_cache=$LFS/sources

# Create source cache

if [ ! -d "${_src_cache}" ]; then
   mkdir "${_src_cache}"
fi

function cleanup {
  files_to_keep=$1

  for file in *; do
    if ! [[ ${files_to_keep[*]} =~ "${file}" ]]; then
      rm -rf "${file}"
    fi
  done
}

# Helper functions for stage-scripts

function validate_file() {
  file=$1
  md5=$2

  echo $md5 $file | md5sum -c &>/dev/null
}

function download_file() {
  local url=$1
  local md5=$2
  local filename=$(basename $url)

  if [ ! -f "${_src_cache}/$filename" ]; then
    echo "Downloading $filename"
    wget -P "${_src_cache}" $url --progress=dot 2>&1
  fi

  if ! validate_file "${_src_cache}/$filename" $md5; then
    echo "File $filename appears to be corrupt, remove it and start build again."
    exit 2
  fi
}

function fetch() {
  local url=$1
  local md5=$2
  local filename=$(basename $url)

  download_file $url $md5

  pkgname=${filename%-*.tar.*}

  mkdir $pkgname

  echo "Unpacking ${filename}"
  tar -xf "${_src_cache}/$filename" --strip-components=1 -C $pkgname

  if [ "$#" -lt 3 ] || [ "$3" != "dl-only" ]; then
    pushd $pkgname &>/dev/null
  fi
}

# First argument is a directory
function last_stage_in() {
  basename $(ls $1/[0-9]*-*.sh | sort -r | head -n1) | cut -d- -f1
}

# Takes a directory, a beginning stage and stop stage
function enumerate_stages() {
  local directory=$1
  local first_stage=$2
  local last_stage=$3

  (
    cd ${directory}
    
    for script in $(seq -f '%02g-*.sh' $first_stage $last_stage); do
      [ -f $script ] && echo $script
    done
  )
}

stderr_color=`echo -e '\033[31m'`
reset_color=`echo -e '\033[0m'`

tools=${tools-/tools}

script_directory=$1
first_stage=1

# Find the range of stages to build
stages_found=$(last_stage_in $script_directory)

if [ $# -gt 2 ]; then
  first_stage=$2
  last_stage=$3
else
  last_stage=${2-$stages_found}
fi

if [ $last_stage -gt $stages_found ] || [ $last_stage -eq 0 ]; then
  last_stage=$stages_found
fi

for script in $(enumerate_stages $script_directory $first_stage $last_stage); do
  stage=${script%*.sh}
  _stage_number=${stage%%-*}
  _stage_name=${stage#*-}
  prefix="${reset_color}[${_stage_number}/${last_stage}] ${_stage_name}: "
  keep_files=$(ls)

  (. ${script_directory}/$script) 2> >(sed "s#^#${stderr_color}#") > >(sed "s#^#${prefix}${reset_color}#")

  cleanup "$keep_files"
done