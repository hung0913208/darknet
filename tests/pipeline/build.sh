#!/bin/bash
# - File: build.sh
# - Description: This bash script will be run right after prepare.sh and it will
# be used to build based on current branch you want to Tests

PIPELINE="$(dirname "$0" )"

source $PIPELINE/libraries/Logcat.sh
source $PIPELINE/libraries/Package.sh

SCRIPT="$(basename "$0")"

if [[ $# -gt 0 ]]; then
	MODE=$2
else
	MODE=0
fi

if [[ $# -gt 0 ]]; then
	TYPE=$3
fi

info "You have run on machine ${machine} script ${SCRIPT}"
info "Your current dir now is $(pwd)"
if [ $(which git) ]; then
	# @NOTE: jump to branch's test suite and perform build
	ROOT="$(git rev-parse --show-toplevel)"
	BASE="$ROOT/Base"
	CMAKED="$ROOT/CMakeD"

	if [[ ${#TYPE} -gt 0 ]]; then
		cd $ROOT/build || error "can't cd to $ROOT/build"

		if [ $TYPE = 'Coverage' ]; then
			cat > $ROOT/tests/pipeline/report.sh << EOF
cd $ROOT/build && $ROOT/Tools/Utilities/coverage.sh
EOF

			chmod +x $ROOT/tests/pipeline/report.sh
		fi

		if ! $BASE/Tools/Utilities/reinstall.sh $TYPE >& ./${TYPE}.txt; then
			error """can't build with mod $TYPE, here is the log:
-------------------------------------------------------------------------------

$(cat ./${TYPE}.txt)
"""
		fi

		info "Congratulation, you have passed ${SCRIPT}"
		exit 0
	fi

	BUILDER="$BASE/Tools/Builder/build"
	CODE=0

	# @NOTE: build with bazel
	if which bazel &> /dev/null; then
		if [ -f $ROOT/WORKSPACE ]; then
			if ! bazel build ...; then
				CODE=-1
			elif ! bazel test --test_output=errors ...; then
				CODE=-1
			fi
		fi
	fi

	if [[ ${CODE} -ne 0 ]]; then
		# @NOTE: do this action to prevent using Builder

		rm -fr $ROOT/{.workspace, WORKSPACE}

		# @NOTE: build and test everything with single command only

		if ! $BUILDER --root $ROOT --debug 1 --rebuild 0 --mode $MODE; then
			exit -1
		fi

		exit -1
	else
		# @NOTE: build and test everything with single command only

		if ! $BUILDER --root $ROOT --debug 1 --rebuild 0 --mode 2; then
			exit -1
		fi
	fi
else
	error "Please install git first"
fi

info "Congratulation, you have passed ${SCRIPT}"
