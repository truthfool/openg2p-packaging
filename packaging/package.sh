#!/usr/bin/env bash

export_from_packages(){
  if [ -f $1 ]; then
    IFS=$'\n' packages_file_content=($(cat $1))
    prefix="$2"
    for package in ${packages_file_content[@]}; do
      package=${package//[[:space:]]/}
      if [ -n "$package" ]; then
        if [[ "$package" != "#"* ]]; then
          IFS="=" read -r package_var package_value <<< "$package"
          combo="${prefix}${package_var}"
          if [ -z "${!combo}" ];then
            export $combo=$package_value
          fi
        fi
      fi
    done
  fi
}

export_from_env(){
  set -a
  source "$1"
  set +a
}

get_final_prefix(){
  PREFIX=$1
  PACKAGE_FILE_NAME=$(basename $2 ".txt")
  PACKAGE_FILE_NAME=${PACKAGE_FILE_NAME//\./_}
  PACKAGE_FILE_NAME=${PACKAGE_FILE_NAME//\-/_}
  PACKAGE_FILE_NAME=${PACKAGE_FILE_NAME//[[:space:]]/}
  echo "${PREFIX}${PACKAGE_FILE_NAME}_"
}

get_vars_from_prefix(){
  PACKAGES_VARS=()
  PACKAGES_VALUES=()
  prefix=$1
  IFS=$'\n' packages_list=($(awk 'BEGIN{for(v in ENVIRON) print v}' | grep "^$prefix"))
  for package in ${packages_list[@]}; do
    if [[ "${!package}" != "#"* ]]; then
      PACKAGES_VALUES+=("${!package}")
      var=${package#"$prefix"}
      PACKAGES_VARS+=(${var//_/-})
    fi
  done
  export PACKAGES_VALUES
  export PACKAGES_VARS
}

PREFIX="G2P_PACKAGE_"
TMPDIR="tmpdir"
GIT_PREFIX="git://"
FILE_PREFIX="file://"

if [ $# -ge 1 ] ; then
  PACKAGE_TXT_PATH="$1"
else
  PACKAGE_TXT_PATH="packages.txt"
fi

PREFIX=$(get_final_prefix $PREFIX $PACKAGE_TXT_PATH)

if [ -z $OCA_DEPENDENCY_VERSION ]; then
  export OCA_DEPENDENCY_VERSION="15.0"
fi

export_from_packages $PACKAGE_TXT_PATH $PREFIX
if [ -f .env ]; then
  export_from_env .env
fi

get_vars_from_prefix $PREFIX

rm -rf $TMPDIR
mkdir $TMPDIR

for i in ${!PACKAGES_VARS[@]}; do
  package_value=${PACKAGES_VALUES[i]}
  if [[ ${PACKAGES_VALUES[i]} == "$GIT_PREFIX"* ]]; then
    package_value=${package_value#"$GIT_PREFIX"}
    branch_name=${package_value%%"//"*}
    git_address=${package_value#*"//"}
    git clone -b ${branch_name} ${git_address} $TMPDIR/${PACKAGES_VARS[i]}
  elif [[ ${PACKAGES_VALUES[i]} == "$FILE_PREFIX"* ]]; then
    package_value=${package_value#"$FILE_PREFIX"}
    cp -r $package_value $TMPDIR/${PACKAGES_VARS[i]}
  fi
done

for dir in $TMPDIR/*/; do
  if [[ -f "${dir}oca_dependencies.txt" ]]; then
    IFS=$'\n' deps=($(cat ${dir}oca_dependencies.txt))
    for i in ${!deps[@]}; do
      if [[ "${deps[i]//[[:space:]]/}" != "#"* ]]; then
        if ! [[ -d "$TMPDIR/${deps[i]}" ]];then
          git clone -b $OCA_DEPENDENCY_VERSION https://github.com/OCA/${deps[i]} $TMPDIR/${deps[i]}
        fi
      fi
    done
  fi
done
