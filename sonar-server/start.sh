#!/bin/bash
set -e

# Convert COMMAND variable into an array
# Simulating positional parameter behaviour
IFS=' ' read -r -a CMD_ARRAY <<< "$COMMAND"

# explicitly setting positional parameters ($@) to CMD_ARRAY
# Add logstash as command if needed i.e. when
# Add elasticsearch as command if needed
if [ "${CMD_ARRAY[0]:0:1}" = '-' ]; then
	set -- "$COMMAND" "${CMD_ARRAY[@]}"
else
	set -- "${CMD_ARRAY[@]}"
fi

# Run as user "stakater"
if [ "$1" = "$COMMAND" ];
then
	set -- su-exec stakater /sbin/tini -- "$@"
else
	# As argument is not related to sonarqube,
	# then assume that user wants to run his own process,
	# for example a `bash` shell to explore this image
	exec "$@"
fi
