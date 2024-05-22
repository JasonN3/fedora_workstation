#!/bin/bash

if ! (authselect current | grep with-smartcard-required)
then
    authselect enable-feature with-smartcard-required
fi
