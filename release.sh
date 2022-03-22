#!/bin/bash

export MIX_ENV=perso
mix deps.get --only prod
mix sentry_recompile
mix release
