#!/bin/bash
set -e

# Parse script params and define variable after transformations
assignScriptParamsToVariables() {
	paramList=$1
  for param in $paramList
  do
    case $param in (*=*)
			echo $param
			eval "$(echo $param | sed 's/--//g')"
		esac
	done
}

clearScriptCustomParams() {
	sourceList=$1
	ignoredItems=$2
	destList=()

  for param in $sourceList
  do
		key="$(echo $param | sed 's/=.*//')"

		if ! [[ " $ignoredItems " =~ .*\ $key\ .* ]]; then
			destList+=("$param")
		fi
	done

	# Return cleared list
	echo "${destList[@]}"
}

if [[ "$*" == *--configUrl* ]]; then
	assignScriptParamsToVariables "$*"

	branch=${configBranch:-master}
	migrationConfigPath=${migrationConfigPath:-migration-config}

	# It was defined with assignScriptParamsToVariables func
	# shellcheck disable=SC2154
	git clone --single-branch -b "$branch" "$configUrl" ~/project

	# We can't pass custom arguments to liquibase because error will be. So we have to remove all of them before.
	ignoredItems=("--configUrl --configBranch --migrationConfigPath")
	preparedParams="$(clearScriptCustomParams "$*" "${ignoredItems[@]}")"

	pathToConfig=~/"project/$migrationConfigPath"
	pathToProperties="$pathToConfig/liquibase.docker.properties"

	# run liquibase with updated params
	bash /liquibase/docker-entrypoint.sh --defaultsFile="$pathToProperties" --classPath="$pathToConfig" "$preparedParams"
else
	bash /liquibase/docker-entrypoint.sh "$@"
fi
