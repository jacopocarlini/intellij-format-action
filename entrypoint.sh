#!/bin/sh

set -eu

/jb/idea/bin/inspect.sh ${GITHUB_WORKSPACE}/ ${GITHUB_WORKSPACE}/Default.xml ${GITHUB_WORKSPACE}/target/idea_inspections -v2

/analyze_inspections.py -i ${GITHUB_WORKSPACE}/target/idea_inspections
