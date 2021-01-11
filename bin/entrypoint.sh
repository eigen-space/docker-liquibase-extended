#!/bin/bash
set -e

# Parse script params and define variable after transformations
assignScriptParamsToVariables() {
	local paramList=$1
	for param in $paramList; do
		case $param in (*=*)
			# shellcheck disable=SC2001
			# shellcheck disable=SC2086
			eval "$(echo $param | sed 's/--//g')"
		esac
	done
}

clearScriptCustomParams() {
	local sourceList=$1
	local ignoredItems=$2
	local destList=()

	for param in  $sourceList; do
		local key
		# shellcheck disable=SC2001
		# shellcheck disable=SC2086
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

	projectConfigPath=~/project

	# It was defined with assignScriptParamsToVariables func
	# shellcheck disable=SC2154
	git clone --single-branch -b "$branch" "$configUrl" $projectConfigPath

	# We can't pass custom arguments to liquibase because error will be. So we have to remove all of them before.
	ignoredItems=("--configUrl --configBranch --migrationConfigPath")
	preparedParams="$(clearScriptCustomParams "$*" "${ignoredItems[@]}")"

	pathToConfig="$projectConfigPath/$migrationConfigPath"
	pathToProperties="$pathToConfig/liquibase.docker.properties"

	echo defaultsFile: "$pathToProperties"
	echo pathToConfig: "$pathToConfig"
	echo preparedParams: "$preparedParams"

	# run liquibase with updated params
	bash /liquibase/docker-entrypoint.sh --defaultsFile="$pathToProperties" --classPath="$pathToConfig" $preparedParams
else
	bash /liquibase/docker-entrypoint.sh "$@"
fi
