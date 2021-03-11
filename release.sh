#!/bin/bash

mix deps.get --only prod
MIX_ENV=perso mix release
