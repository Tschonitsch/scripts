#!/bin/bash

if ! command -v ddcutil &> /dev/null; then
    echo "Error: ddcutil is not installed. Please install it first."
    exit 1
fi

echo "Detecting monitors..."

echo ""
echo "╭─────────────╮"
ddcutil detect | grep "Display" | awk '{printf "│ %-11s │\n", $0}'
echo "╰─────────────╯"

echo ""
echo "Enter display number (0 = ALL):"
read display

echo ""
echo "Enter brightness (0–100):"
read brightness

if [[ -z "$brightness" ]]; then
    echo "No brightness value entered."
    exit 1
fi

get_displays() {
    ddcutil detect | grep "Display" | awk '{print $2}'
}

if [[ "$display" == "0" ]]; then
    echo ""
    echo "Setting brightness for ALL monitors to $brightness"
    echo ""

    for d in $(get_displays); do
        echo "Display $d"
        ddcutil setvcp 10 "$brightness" --display "$d"
    done

else
    echo ""
    echo "Setting brightness for display $display to $brightness"
    echo ""
    ddcutil setvcp 10 "$brightness" --display "$display"
fi

echo ""
echo "Done."