#!/bin/bash

# defensive error handling
set -euo pipefail

# move into the folder of this script
cd "$(dirname "$0")"

# copying `backend` to `backend/.vercel/...` directly may cause problems
cp -RP apps/backend/. apps/backend-copy/
# `shopt` includes dot-files in the `mv` operation
rm -rf apps/deployment
pnpm install
pnpm build:frontend
mkdir -p apps/backend/.vercel/output/static/frontend/
cp -RP apps/frontend/build/. apps/backend/.vercel/output/static/frontend/

# Copy the built api.func function to specific subpath routes to enable original URL routing

# Clean destinations first to handle Vercel build caching safely
rm -rf apps/backend/.vercel/output/functions/api
mkdir -p apps/backend/.vercel/output/functions/api

# Duplicate the built api.func to specific subpath routes
cp -RP apps/backend/.vercel/output/functions/api.func apps/backend/.vercel/output/functions/api/top-langs.func
cp -RP apps/backend/.vercel/output/functions/api.func apps/backend/.vercel/output/functions/api/gist.func
cp -RP apps/backend/.vercel/output/functions/api.func apps/backend/.vercel/output/functions/api/pin.func
cp -RP apps/backend/.vercel/output/functions/api.func apps/backend/.vercel/output/functions/api/wakatime.func
