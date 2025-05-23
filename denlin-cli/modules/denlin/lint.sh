#!/bin/bash
# modules/denlin/lint.sh
# Menu: Denlin
# Description: Lint all module scripts to ensure quality and consistency

MODULE_DIR="/usr/local/bin/denlin-cli/modules"
declare -a summary
EXIT_CODE=0

# ANSI colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Function to wrap ✅ or ❌ in color
pass() { echo -e "${GREEN}✅${RESET}"; }
fail() { echo -e "${RED}❌${RESET}"; }

echo
echo "=== Denlin Module Linter ==="
echo "Scanning module scripts in: $MODULE_DIR"
echo

# Header for the summary table
summary+=("Script Path|Shebang|Path Comment|Menu|Description|Executable")

# Lint each .sh script
find "$MODULE_DIR" -type f -name "*.sh" | sort | while read -r file; do
    rel_path="${file#$MODULE_DIR/}"

    [ -x "$file" ] && exec_flag=$(pass) || { exec_flag=$(fail); EXIT_CODE=1; }
    grep -q "^#!/bin/bash" "$file" && shebang_flag=$(pass) || { shebang_flag=$(fail); EXIT_CODE=1; }
    grep -q "# modules/$rel_path" "$file" && path_flag=$(pass) || { path_flag=$(fail); EXIT_CODE=1; }
    grep -q "^# Menu:" "$file" && menu_flag=$(pass) || { menu_flag=$(fail); EXIT_CODE=1; }
    grep -q "^# Description:" "$file" && desc_flag=$(pass) || { desc_flag=$(fail); EXIT_CODE=1; }

    summary+=("$rel_path|$shebang_flag|$path_flag|$menu_flag|$desc_flag|$exec_flag")
done

# Print table
echo
printf "%-50s | %-7s | %-12s | %-6s | %-11s | %-10s\n" "Script Path" "Shebang" "Path Comment" "Menu" "Description" "Executable"
printf -- "-----------------------------------------------------------------------------------------------------------------------------\n"

for row in "${summary[@]:1}"; do
    IFS='|' read -r path sh pc menu desc exec <<< "$row"
    printf "%-50s | %s   | %s       | %s   | %s        | %s\n" "$path" "$sh" "$pc" "$menu" "$desc" "$exec"
done

echo
if [ "$EXIT_CODE" -eq 0 ]; then
    echo -e "${GREEN}✅ All module scripts passed linting!${RESET}"
else
    echo -e "${RED}⚠️ Some scripts have issues. Please review the table above.${RESET}"
fi

# Ask if user wants to save report
echo
read -rp "📄 Do you want to save this lint report to a file? (y/N): " save_report
if [[ "$save_report" =~ ^[Yy]$ ]]; then
    REPORT_PATH="./lint-report.txt"
    {
        echo "Denlin Module Lint Report"
        echo "Generated on: $(date)"
        echo
        printf "%-50s | %-7s | %-12s | %-6s | %-11s | %-10s\n" "Script Path" "Shebang" "Path Comment" "Menu" "Description" "Executable"
        printf -- "-----------------------------------------------------------------------------------------------------------------------------\n"
        for row in "${summary[@]:1}"; do
            IFS='|' read -r path sh pc menu desc exec <<< "$row"
            printf "%-50s | %s   | %s       | %s   | %s        | %s\n" "$path" "$sh" "$pc" "$menu" "$desc" "$exec"
        done
    } > "$REPORT_PATH"

    echo "✅ Report saved to: $REPORT_PATH"
fi

exit "$EXIT_CODE"
