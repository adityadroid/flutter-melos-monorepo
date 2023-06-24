#!/bin/bash

# Function to copy and modify the run configuration files
copy_run_configs() {
    local app_name="$1"
    local source_dir="./apps/$app_name/.idea/runConfigurations"
    local destination_dir="./.idea/runConfigurations"

    # Create destination directory if it doesn't exist
    mkdir -p "$destination_dir"

    # Copy files and modify their content
    for file in "$source_dir"/*; do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local modified_filename="flutter_run_${app_name}_${filename}"
            local existing_content=$(cat "$file")

            local modified_content=$(echo "$existing_content" | sed -e "s|<option name=\"filePath\" value=\"\$PROJECT_DIR\$/|<option name=\"filePath\" value=\"\$PROJECT_DIR\$/apps/$app_name/|g" \
                                                                 -e "s|<configuration default=\"false\" name=\"|<configuration default=\"false\" name=\"$app_name -\&gt; |g")

            echo "$modified_content" > "$destination_dir/$modified_filename"
        fi
    done
}

# Recursively process app folders
process_apps() {
    local apps_dir="./apps"

    # Loop through all app folders
    for app in "$apps_dir"/*; do
        if [[ -d "$app" ]]; then
            local app_name=$(basename "$app")
            copy_run_configs "$app_name"
        fi
    done
}

# Call the function to start the process
process_apps
