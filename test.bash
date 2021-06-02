#!/usr/bin/env bash
set -meuo pipefail

. venv/bin/activate

set -x

mkdocs --version

mkdocs serve &
SERVE_PID=$!

sleep 3                    # let mkdocs serve start-up
touch README.md            # modify a file to trigger build
sleep 3                    # let mkdocs serve build
kill -int $SERVE_PID       # signal mkdocs serve to shut down
sleep 2                    # let mkdocs serve shutdown

set +x
echo "******* server down ********"
