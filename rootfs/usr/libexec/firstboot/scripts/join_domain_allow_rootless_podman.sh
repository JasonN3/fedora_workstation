#!/bin/bash

if ! (authselect current | grep with-subid)
then
    authselect enable-feature with-subuid
fi
