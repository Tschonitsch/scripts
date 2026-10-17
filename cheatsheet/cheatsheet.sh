#!/usr/bin/env bash

CHEATSHEET="$(dirname -- "${BASH_SOURCE[0]}")/cheatsheet.txt"

if [[ ! -f "$CHEATSHEET" ]]; then
    echo "Error: Cheatsheet not found: $CHEATSHEET"
    exit 1
fi

# Read category names from section headers.
mapfile -t categories < <(
    sed -n 's/^# ---------- \(.*\) ----------$/\1/p' "$CHEATSHEET" |
    awk '!seen[$0]++'
)

if ((${#categories[@]} == 0)); then
    echo "No categories found in $CHEATSHEET"
    exit 1
fi

while true; do
    clear
    echo " _____ _                _     _____ _               _   ";
    echo "/  __ \\ |              | |   /  ___| |             | |  ";
    echo "| /  \\/ |__   ___  __ _| |_  \\ \`--.| |__   ___  ___| |_ ";
    echo "| |   | '_ \\ / _ \\/ _\` | __|  \`--. \\ '_ \\ / _ \\/ _ \\ __|";
    echo "| \\__/\\ | | |  __/ (_| | |_  /\\__/ / | | |  __/  __/ |_ ";
    echo " \\____/_| |_|\\___|\\__,_|\\__| \\____/|_| |_|\\___|\\___|\\__|";
    echo "--------------------------------------------------------";
    echo "";

    PS3="Select a category (or Exit): "

    select category in "${categories[@]}" "Exit"; do
        if [[ "$category" == "Exit" ]]; then
            clear
            exit 0
        fi

        if [[ -z "$category" ]]; then
            echo "Invalid selection. Try again."
            continue
        fi

        clear

        # Print the selected section, including both headers.
        awk -v wanted="$category" '
            $0 == "# ---------- " wanted " ----------" {
                if (!printing) {
                    printing = 1
                } else {
                    print
                    exit
                }
            }
            printing { print }
        ' "$CHEATSHEET"

        echo
        read -r -p "Press Enter to return to menu..."
        break
    done
done

