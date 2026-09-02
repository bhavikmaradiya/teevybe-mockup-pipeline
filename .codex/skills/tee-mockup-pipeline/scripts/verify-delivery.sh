#!/bin/sh

# Read-only mechanical verifier for a TeeVybe batch delivery folder.
# It never creates, edits, copies, converts, or deletes an asset.

set -u

usage() {
  echo "Usage: $0 <batch-directory> [--shared-06]" >&2
  exit 2
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage

batch_dir=$1
shared_06=false
if [ "$#" -eq 2 ]; then
  [ "$2" = "--shared-06" ] || usage
  shared_06=true
fi

failures=0

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  failures=$((failures + 1))
}

if [ ! -d "$batch_dir" ]; then
  fail "batch directory does not exist: $batch_dir"
  exit 1
fi

for command_name in find file sips shasum cmp awk wc tr; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    fail "required read-only command is unavailable: $command_name"
  fi
done
[ "$failures" -eq 0 ] || exit 1

root_entry_count=$(find "$batch_dir" -mindepth 1 -maxdepth 1 ! -name '.DS_Store' -print | wc -l | tr -d ' ')
if [ "$root_entry_count" -eq 2 ] && [ -d "$batch_dir/Men" ] && [ -d "$batch_dir/Women" ]; then
  pass "batch root contains exactly Men and Women"
else
  fail "batch root must contain exactly two entries: Men and Women"
fi

for gender in Men Women; do
  gender_dir="$batch_dir/$gender"
  if [ ! -d "$gender_dir" ]; then
    fail "$gender directory is missing"
    continue
  fi

  entry_count=$(find "$gender_dir" -mindepth 1 -maxdepth 1 ! -name '.DS_Store' -print | wc -l | tr -d ' ')
  if [ "$entry_count" -eq 7 ]; then
    pass "$gender contains exactly seven files"
  else
    fail "$gender must contain exactly seven files; found $entry_count"
  fi

  number=1
  while [ "$number" -le 7 ]; do
    filename=$(printf '%02d.jpg' "$number")
    expected_mime='image/jpeg'
    expected_width='1080'
    expected_height='1440'
    image_path="$gender_dir/$filename"
    if [ ! -f "$image_path" ]; then
      fail "$gender/$filename is missing"
      number=$((number + 1))
      continue
    fi

    mime_type=$(file -b --mime-type "$image_path" 2>/dev/null || true)
    if [ "$mime_type" = "$expected_mime" ]; then
      pass "$gender/$filename has expected MIME type $expected_mime"
    else
      fail "$gender/$filename has MIME type $mime_type instead of $expected_mime"
    fi

    width=$(sips -g pixelWidth "$image_path" 2>/dev/null | awk '/pixelWidth/ {print $2}')
    height=$(sips -g pixelHeight "$image_path" 2>/dev/null | awk '/pixelHeight/ {print $2}')
    if [ "$width" = "$expected_width" ] && [ "$height" = "$expected_height" ]; then
      pass "$gender/$filename is ${expected_width}x${expected_height}"
    else
      fail "$gender/$filename is ${width:-unknown}x${height:-unknown}, expected ${expected_width}x${expected_height}"
    fi

    checksum=$(shasum -a 256 "$image_path" | awk '{print $1}')
    printf 'SHA256: %s  %s/%s\n' "$checksum" "$gender" "$filename"
    number=$((number + 1))
  done
done

men_07="$batch_dir/Men/07.jpg"
women_07="$batch_dir/Women/07.jpg"
if [ -f "$men_07" ] && [ -f "$women_07" ] && cmp -s "$men_07" "$women_07"; then
  pass "Men/07.jpg and Women/07.jpg are byte-identical"
else
  fail "Men/07.jpg and Women/07.jpg must be byte-identical"
fi

if [ "$shared_06" = true ]; then
  men_06="$batch_dir/Men/06.jpg"
  women_06="$batch_dir/Women/06.jpg"
  if [ -f "$men_06" ] && [ -f "$women_06" ] && cmp -s "$men_06" "$women_06"; then
    pass "shared Men/06.jpg and Women/06.jpg are byte-identical"
  else
    fail "--shared-06 requires Men/06.jpg and Women/06.jpg to be byte-identical"
  fi
fi

if [ "$failures" -eq 0 ]; then
  echo "RESULT: PASS"
  exit 0
fi

printf 'RESULT: FAIL (%s mechanical issue(s))\n' "$failures" >&2
exit 1
