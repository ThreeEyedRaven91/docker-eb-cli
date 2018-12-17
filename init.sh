#!/bin/sh

mkdir -p .elasticbeanstalk
/bin/cat <<EOM > .elasticbeanstalk/config.yml
branch-defaults:
  develop:
    environment: $1
environment-defaults:
  $1:
    branch: null
    repository: null
global:
  application_name: $2
  default_region: $3
  include_git_submodules: true
  instance_profile: null
  platform_name: null
  platform_version: null
  profile: eb-cli
  sc: git
  workspace_type: Application
EOM