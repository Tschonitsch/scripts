#!/bin/bash

STEAMAPPS="$HOME/.local/share/Steam/steamapps"

cd "$STEAMAPPS" || exit

selected=$(
  for f in appmanifest_*.acf; do
    appid=$(grep -m1 '"appid"' "$f" | cut -d '"' -f4)
    name=$(grep -m1 '"name"' "$f" | cut -d '"' -f4)
    echo "$appid | $name"
  done | fzf \
    --delimiter="|" \
    --layout=reverse \
    --border=rounded \
    --prompt="Select your game: " \
    --with-nth=2 \
    --preview-window=right:50% \
    --preview='
      appid=$(echo {} | cut -d"|" -f1 | xargs)
      file="appmanifest_${appid}.acf"

      size=$(grep -m1 "\"SizeOnDisk\"" "$file" | cut -d "\"" -f4)

      echo "AppID: $appid"
      echo "Name: $(echo {} | cut -d"|" -f2 )"
      
      echo "Size: $(numfmt --to=iec-i --suffix=B "$size")"
    '
)

appid=$(echo "$selected" | cut -d"|" -f1 | xargs)

[ -n "$appid" ] && steam "steam://rungameid/$appid"