#    ___                _   _                 
#   / __\ _ _ __   ___| |_(_) ___  _ __  ___ 
#  / _\| | | '_ \ / __| __| |/ _ \| '_ \/ __|
# / /  | |_| | | | (__| |_| | (_) | | | \__ \
# \/    \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#

# Usage: testenv "<tags>" [path/to/.env]
# TEST_URL is taken from the clipboard (macOS pbpaste); TEST_TAGS is the first argument.
testenv() {
  local file="${2:-.vscode/test-run.env}"
  [[ -f $file ]] || { echo "No such file: $file" >&2; return 1; }

  TAGS="$1" URL="$(pbpaste)" \
    perl -pi -e 's/^TEST_TAGS=.*/TEST_TAGS=$ENV{TAGS}/; s/^TEST_URL=.*/TEST_URL=$ENV{URL}/' "$file"

  grep -E '^TEST_(TAGS|URL)=' "$file"
}
