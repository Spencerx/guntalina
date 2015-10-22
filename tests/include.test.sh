#!/bin/bash

init

config <<DATA
actions:
    # separated includes
    !include conf.d/good/actions
    !include conf.d/bad/actions

rules:
    # include by glob pattern
    !include conf.d/*/rules
DATA

confd "good" "actions" <<DATA
    reload-something:
        commands:
            - echo command_1
            - echo command_2
DATA

confd "bad" "actions" <<DATA
    should-be-not-executed:
        commands:
            - echo something went wrong
DATA

confd "good" "rules" <<DATA
    - masks:
        - /etc/something/something.conf
        - /etc/something/conf.d/*
      workflow:
        - reload-something
DATA

confd "bad" "rules" <<DATA
    - masks:
        - /should/be/not/globbed/
        - /should/*/*/globbed/
      workflow:
        - should-be-not-executed
DATA

sources <<DATA
/etc/hosts
/etc/host.conf
/etc/something/something.conf
/should/blah/
/blah/globbed/
DATA


tests_ensure run

tests_ensure assert_diff <<DATA
following actions will be executed:
reload-something
    echo command_1
    echo command_2

following commands will be executed:
echo command_1
echo command_2

executing: echo command_1
command_1

executing: echo command_2
command_2
DATA
