#!/bin/bash
_sonarqube_version=$1
_sonarqube_tag=$2
_release_build=false

if [ -z "${_sonarqube_version}" ]; then
	source SONARQUBE_VERSION
	_sonarqube_version=$SONARQUBE_VERSION
	_sonarqube_tag=$SONARQUBE_VERSION
	_release_build=true
fi

echo "SONARQUBE_VERSION: ${_sonarqube_version}"
echo "DOCKER TAG: ${_sonarqube_tag}"
echo "RELEASE BUILD: ${_release_build}"

docker build --build-arg SONARQUBE_VERSION=${_sonarqube_version} --tag "stakater/sonarqube:${_sonarqube_tag}"  --no-cache=true .

if [ $_release_build == true ]; then
	docker tag "stakater/sonarqube:${_sonarqube_tag}" "stakater/sonarqube:latest"
fi
