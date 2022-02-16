#!/bin/bash

mix deps.get --only prod
mix sentry_recompile
MIX_ENV=perso mix release
