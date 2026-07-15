#!/bin/bash

# defensive error handling
set -euo pipefail

# move into the folder of this script
cd "$(dirname "$0")"

mkdir -p apps/backend/.vercel/output/functions/api.func/
# copying `backend` to `backend/.vercel/...` directly may cause problems
cp -RP apps/backend/. apps/backend-copy/
# `shopt` includes dot-files in the `mv` operation
(shopt -s dotglob && mv apps/backend-copy/* apps/backend/.vercel/output/functions/api.func/)
cp -RP apps/backend/.vercel/output/functions/api.func/_dot_vercel_copy/output apps/backend/.vercel/
rm -rf apps/deployment
pnpm install
pnpm build:frontend
mkdir -p apps/backend/.vercel/output/static/frontend/
cp -RP apps/frontend/build/. apps/backend/.vercel/output/static/frontend/

# Copy the built api.func function to specific subpath routes to enable original URL routing
mkdir -p apps/backend/.vercel/output/functions/api/
cp -RP apps/backend/.vercel/output/functions/api.func/ apps/backend/.vercel/output/functions/api/top-langs.func/
cp -RP apps/backend/.vercel/output/functions/api.func/ apps/backend/.vercel/output/functions/api/gist.func/
cp -RP apps/backend/.vercel/output/functions/api.func/ apps/backend/.vercel/output/functions/api/pin.func/
cp -RP apps/backend/.vercel/output/functions/api.func/ apps/backend/.vercel/output/functions/api/wakatime.func/
