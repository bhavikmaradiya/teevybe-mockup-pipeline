#!/usr/bin/env bash
set -euo pipefail

shared_06=false
if [[ "${1:-}" == "--shared-06" ]]; then
  shared_06=true
  shift
fi

if [[ $# -ne 1 ]]; then
  echo "usage: verify-delivery.sh [--shared-06] <batch-directory>" >&2
  exit 2
fi

batch_dir=$1
if [[ ! -d "$batch_dir" ]]; then
  echo "missing batch directory: $batch_dir" >&2
  exit 1
fi

actual_root=$(find "$batch_dir" -mindepth 1 -maxdepth 1 -exec basename {} \; | sort | tr '\n' ' ')
if [[ "$actual_root" != "Men Women " ]]; then
  echo "invalid batch root structure" >&2
  exit 1
fi

for gender in Men Women; do
  gender_dir="$batch_dir/$gender"
  [[ -d "$gender_dir" ]] || { echo "missing $gender directory" >&2; exit 1; }
  files=$(find "$gender_dir" -mindepth 1 -maxdepth 1 -type f -exec basename {} \; | sort | tr '\n' ' ')
  expected="01.jpg 02.jpg 03.jpg 04.jpg 05.jpg 06.jpg 07.jpg "
  if [[ "$files" != "$expected" ]]; then
    echo "invalid $gender file structure" >&2
    exit 1
  fi
  for number in 01.jpg 02.jpg 03.jpg 04.jpg 05.jpg 06.jpg 07.jpg; do
    path="$gender_dir/$number"
    [[ "$(file -b --mime-type "$path")" == "image/jpeg" ]] || { echo "not JPEG: $path" >&2; exit 1; }
    width=$(sips -g pixelWidth "$path" | awk '/pixelWidth/ {print $2}')
    height=$(sips -g pixelHeight "$path" | awk '/pixelHeight/ {print $2}')
    [[ "$width" == 1080 && "$height" == 1440 ]] || { echo "invalid dimensions: $path" >&2; exit 1; }
  done
done

cmp -s "$batch_dir/Men/07.jpg" "$batch_dir/Women/07.jpg" || { echo "07 files are not byte-identical" >&2; exit 1; }
if [[ "$shared_06" == true ]]; then
  cmp -s "$batch_dir/Men/06.jpg" "$batch_dir/Women/06.jpg" || { echo "06 files are not byte-identical" >&2; exit 1; }
fi

echo "PASS: delivery structure, JPEG MIME, 1080x1440 dimensions, and shared asset checks."
